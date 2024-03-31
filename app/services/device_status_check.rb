class DeviceStatusCheck
  def initialize(idfa, rooted_device, user_country, user_ip)
    @idfa = idfa
    @rooted_device = rooted_device
    @user_country = user_country
    @user_ip = user_ip
    initialize_redis_cache
  end

  def valid?
    country_check && !rooted_device && ip_check
  end

  private

  attr_reader :idfa, :rooted_device, :user_country, :user_ip

  def initialize_redis_cache
    body = $redis.get(idfa) ? JSON.parse($redis.get(idfa), symbolize_names: true) : {}
    body[:rooted_device] = rooted_device
    body[:country] = user_country
    body[:ip] = user_ip

    $redis.set(idfa, body.to_json, ex: 86400)
  end

  def country_check
    CountryCheck.new(user_country).valid?
  end

  def ip_check
    IpCheck.new(idfa, user_ip).valid?
  end
end
