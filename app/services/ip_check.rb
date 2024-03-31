class IpCheck
  KEYS = [:vpn, :tor].freeze

  def initialize(idfa, ip_address)
    @idfa = idfa
    @ip_address = ip_address
  end

  def valid?
    response = cached_response || vpn_api_response

    !response[:security][:vpn] && !response[:security][:tor]
  end

  private

  attr_reader :idfa, :ip_address

  def cached_response
    response = $redis.get(idfa)
    body = JSON.parse(response, symbolize_names: true)

    body if body.present? && body[:security].present? && KEYS.all? { |k| body[:security].keys.include?(k) }
  end

  def vpn_api_response
    VpnApiResponse.new(idfa, ip_address).call
  end
end
