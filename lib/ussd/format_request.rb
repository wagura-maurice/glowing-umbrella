module FormatRequest

  # Formats the form response for the USSD gateway
  def format_response(response, continue)
    if @gateway == :africas_talking
      if continue
        response = "CON " + response
      else
        response = "END " + response
      end
    end
    return response
  end

end