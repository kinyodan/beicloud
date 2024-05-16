# frozen_string_literal: true

module ApiServices
  extend ActiveSupport::Concern

  def api_services_request_get_Product(url)
    uri = URI(url.to_s)

    res = Net::HTTP.get_response(uri, @headers)
    response = res.body if res.is_a?(Net::HTTPSuccess)
    # p response
    return nil unless response

    response_body = JSON.parse response
    response
    #   if response_body["status"]
    #     return response_body["data"]
    #   else
    #     return nil
    #   end
  end

  def request_verify_authentication(aut_params)
    auth_token = { token: @aut_params[:s] }
    uri = URI("#{ENV['API_URL']}/api/v1/verify_authentication")
    aut_params = [{}]

    headers = {
      'Authorization' => auth_token.to_json,
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri.path, aut_params.to_json, headers)
    JSON.parse response.body
  end
end
