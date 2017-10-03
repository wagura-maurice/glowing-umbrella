require 'openssl'
require 'base64'
require 'uri'
require 'api/hash_helper'


class HMacHelper

  def self.format_request_string(http_verb, uri, api_key, timestamp, params = nil)
    clean_http_verb = self.format_http_verb(http_verb)
    clean_uri = self.extract_api_endpoint_from_uri(uri)
    clean_api_key = self.format_api_key(api_key)
    clean_timestamp = self.format_timestamp(timestamp)
    clean_params = self.format_custom_params(params)

    # Put the base query together, without the optional GET/POST params for now.
    formatted_query = "#{clean_http_verb}\n#{clean_uri}\n#{clean_params}\nApiKey=#{clean_api_key}\nTimestamp=#{clean_timestamp}\n"
  end


  def self.format_http_verb(http_verb)
    http_verb.strip.upcase
  end


  def self.extract_api_endpoint_from_uri(uri)
    clean_uri = uri.downcase.strip.chomp("/").gsub /https?:\/\//, "" # Remove protocol
    clean_uri.gsub /\?.*/, "" # Remove query params. See byte order below
  end


  def self.format_api_key(api_key)
    #Rails automatically URL decodes parameters
    #Hence URL escape it again to ensure an identical signature calculation
    unless api_key.include? "%20"
      return URI.escape(api_key)
    end
    api_key
  end


  def self.format_timestamp(timestamp)
    #Rails automatically URL decodes the timestamp or any parameter for that fact
    #Hence URL escape it again to ensure an identical signature calculation
    unless timestamp.include? "%20"
      return URI.escape(timestamp)
    end
    timestamp
  end


  def self.format_custom_params(params)
    if params && params.size > 0
      sorted_params = ""

      # Rails submits PUT/POST calls with nested attributes. Sample:
      # params: {
      #           user: {
      #                   first_name: "John",
      #                   last_name: "Doe"
      #                 }
      #         }
      # We hence we recursively parse the tree and flatten the hash to format the query.
      flat_hash = HashHelper.flatten_hash params
      sorted_flat_hash = flat_hash.sort.to_h #Ruby sorts in ASCII byte order. Hurray
      sorted_flat_hash.each do |k, v|
        value = v.to_s
        if v.is_a?(Array)
          value = "[#{v.join(",")}]"
        end
        sorted_params << "#{URI.escape(k.to_s)}=#{URI.escape(value)}&"
      end

      sorted_params.chomp! "&" #Remove trailing ampersand
      return "#{sorted_params}\n"
    end
    return ""
  end


  def self.compute_hmac_signature(request_string, api_secret)
    hmac = OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), api_secret, request_string)

    #Base 64 encode the HMac
    base64_signature = Base64.encode64(hmac)

    #Remove whitespace, new lines and trailing equal sign.
    base64_signature.strip().chomp("=")
  end
end
