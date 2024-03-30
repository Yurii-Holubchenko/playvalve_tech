class IpCheck
  def initialize(idfa, ip_address)
    @idfa = idfa
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

  attr_reader :idfa, :ip_address, :api_key

  def cached_response
    keys = [:proxy, :vpn]
    response = $redis.get(idfa)
    body = JSON.parse(response, symbolize_names: true)

    (body[:security] && body[:security].keys.all? { |k| keys.include?(k) }) ? body : false
  end

  def vpn_api_request
    Faraday.get("https://vpnapi.io/api/#{ip_address}?key=#{api_key}")
  end

  def vpn_api_response
    response = $redis.get(idfa)
    body = JSON.parse(response, symbolize_names: true)
    api_body = JSON.parse(vpn_api_request.body, symbolize_names: true)
    body.update(api_body)

    $redis.set(idfa, body.to_json)
    body
  end
end
