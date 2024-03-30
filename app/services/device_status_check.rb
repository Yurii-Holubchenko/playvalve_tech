class DeviceStatusCheck
  def initialize(user_country, rooted_device, user_ip)
    @user_country = user_country
    @rooted_device = rooted_device
    @user_ip = user_ip
  end

  def valid?
    country_check && !rooted_device && ip_check
  end

  private

  attr_reader :user_country, :rooted_device, :user_ip

  def country_check
    CountryCheck.new(user_country).valid?
  end

  def ip_check
    IpCheck.new(user_ip).valid?
  end
end
