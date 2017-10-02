require 'uri'
require 'api/h_mac_helper'

class Api::ApiController < ActionController::API

  # All requests ALWAYS MUST be authenticated. Removing this before filter
  # would lead to data leaks and expose clients data to the possibly wrong caller.
  #before_filter :authenticate_request
  before_filter :check_params, :only => [:create, :update]


  def model_symbol
    self.class.to_s.sub(/Api::V\d::/, "").sub("Controller", "").underscore.singularize.to_sym
  end


  def authenticate_request
    # The incoming request will look somewhat like this:
    # https://www.egranary.com/api/v1/farmers
    # With the following headers
    # Authorization: EGRANARY-HMAC-SHA256
    # X-Authorization-ApiKey: AKIAIOSFODNN7EXAMPLE&
    # X-Authorization-Timestamp: 2016-02-20%2001:51:09%20UTC&
    # X-Authorization-Signature: i91nKc4PWAt0JJIdXwz9HxZCJDdiy6cf%2FMj6vPxyYIs%3D
    #
    # We need to authenticate that this request is valid by computing the HMac
    # of the input and then comparing it against the provided signature.
    # If they match, we can set the tenant given on the unique AuroraKey.

    # Pre-process: Log each request
    Rails.logger.info "API Request: '#{request.original_url}'"

    # TODO: Throttle or even block requests or the whole tenant given a certain
    # count of invalid requests per minute.
    # Solution: (Redis a truncated timestamp (per minute) as key + counter as value)

    #Check HMAC base key/secret authentication
    auth_passed, message = authenticated?
    unless auth_passed
      Rails.logger.warn "API Request failed authentication. Error: #{message}"
      render_error_msg message
      return false  #Stop processing this request.
    end
    return true
  end


  # Returns true if the the request authenticates a valid/existing tenant
  # via key/secret based HMAC authentication, false if not.
  # Returns then authenticated tenant id as the second return argument
  # Returns an error message given auth failure as the 3rd return argument
  def authenticated?
    unless request.authorization == 'EGRANARY-HMAC-SHA256'
      return false, "Invalid Authorization Header"
    end
    key, timestamp, signature = request.headers['X-Authorization-ApiKey'], request.headers['X-Authorization-Timestamp'], request.headers['X-Authorization-Signature']

    unless timestamp_valid?(timestamp)
      return false, "Invalid Timestamp"
    end

    # Pre-requirement: Check for mandatory parameters
    unless (key.present? && timestamp.present? && signature.present?)
      return false, "Unable to find required API request attributes"
    end

    # Retrieve the API secret form the DB
    unless key == ENV['EXTERNAL_API_KEY']
      return false, "Invalid API Key"
    end

    # Build canonical request string to sign
    custom_params = request.GET.clone if request.get?
    custom_params = request.POST.clone if request.post? || request.put?
    [:api_key, :timestamp, :signature].each do |k|
      custom_params.delete(k)
    end

    if correct_signature?(key, timestamp, signature, ENV['EXTERNAL_API_SECRET'],
                          custom_params, request.method, request.original_fullpath)
      # Grant access if key is valid
      return true, "Authentication Successful"
    else
      return false, "Invalid Signature"
    end
  end


  def correct_signature?(key, timestamp, provided_signature, api_secret,
      custom_params, request_method, full_path)

    Rails.logger.info "Raw Customer Parameters before flattening: #{custom_params}"
    request_string = HMacHelper.format_request_string(request_method,
                                                      full_path,
                                                      key,
                                                      timestamp,
                                                      custom_params)
    Rails.logger.info "Canonical Request String: #{request_string}"

    # 2.) Sign canonical request/string
    computed_signature = HMacHelper.compute_hmac_signature(request_string, api_secret)

    #Rails will automatically convert any spaces in the URI to + signs when parsing the request
    #Hence we need to prepare for the unlikely but still possible case that a + sign is sent
    #as a valid character of the signature and then converted into a space by accident.
    #This is a safe operation given that URLs should never be unescaped in the URI
    provided_signature.gsub! " ", "+"

    Rails.logger.info "Computed Signature: #{computed_signature}"
    Rails.logger.info "Provided Signature: #{provided_signature}"

    # 3.) Compare computed signature against provided signature
    return true if computed_signature == provided_signature

    false
  end


  def check_params
    invalid_params = get_invalid_params

    unless invalid_params.empty?
      msg = "Received invalid parameters: #{invalid_params}. Permitted parameters are: #{permitted_params}"
      render_error_msg msg
      return false #To stop processing this request.
    end
  end


  def timestamp_valid?(timestamp)
    begin
      time = timestamp.to_time
      valid_time_period = Time.now - 15.minutes
      return time > valid_time_period
    rescue
      return false
    end
  end

  # ========================================================================
  # Private methods
  # ========================================================================
  private

  def get_invalid_params
    invalid_params = []
    params.each do |k, v|
      invalid_params << k unless white_listed_params.include?(k)
    end
    invalid_params.delete('controller')
    invalid_params.delete('action')
    return invalid_params
  end

  def white_listed_params
    return {'controller' => '', 'action' => ''}.merge(permitted_params)
  end

  # By default NO parameters are allowed on update/create. Each subclass of the
  # APIController must implement its own list of permitted parameters, or update/create
  # calls will be rejected with a ActiveModel::ForbiddenAttributesError
  def permitted_params
    [] #Overwrite this method in your controller
  end

  def render_unauthorized
    render :json => nil, :status => :unauthorized
  end

  def render_nothing(status = 200)
    render :json => nil, :status => status
  end

  def render_error_msg(msg)
    render :json => {error: msg}, :status => :unprocessable_entity
  end
end
