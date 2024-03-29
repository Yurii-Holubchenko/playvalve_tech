class IpCheck
  def initialize(ip_address)
    @ip_address = ip_address
    @api_key = Rails.application.credentials.vpn_api.api_key
  end

  def valid?
    response = cached_response || vpn_api_response

    !response[:security][:vpn] && !response[:security][:tor]
  rescue
    true
  end

  private

  attr_reader :ip_address, :api_key

  def cached_response
    response = $redis.get(ip_address)
    JSON.parse(response, symbolize_names: true) if response.present?
  end

  def vpn_api_request
    Faraday.get("https://vpnapi.io/api/#{ip_address}?key=#{api_key}")
  end

  def vpn_api_response
    body = JSON.parse(vpn_api_request.body, symbolize_names: true)
    $redis.set(body[:ip], body.to_json, ex: 86400)
    body
  end
end
