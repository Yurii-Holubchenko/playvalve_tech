class VpnApiResponse
  INVALID_STATUSES = [429, 500].freeze

  def initialize(idfa, ip_address)
    @idfa = idfa
    @ip_address = ip_address
    @api_key = Rails.application.credentials.vpn_api.api_key
  end

  def call
    body = redis_body.merge(api_body)
    $redis.set(idfa, body.to_json)

    body
  end

  private

  attr_reader :idfa, :ip_address, :api_key, :vpn_api_request

  def redis_body
    redis_response = $redis.get(idfa)
    JSON.parse(redis_response, symbolize_names: true)
  end

  def vpn_api_request
    @vpn_api_request ||= Faraday.get("https://vpnapi.io/api/#{ip_address}?key=#{api_key}")
  end

  def api_body
    return {security: {vpn: false, tor: false}} if INVALID_STATUSES.any? { |s| vpn_api_request.status == s }

    JSON.parse(vpn_api_request.body, symbolize_names: true)
  end
end
