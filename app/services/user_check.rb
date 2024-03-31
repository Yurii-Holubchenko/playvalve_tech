class UserCheck
  def initialize(idfa, rooted_device, user_country, user_ip)
    @idfa = idfa
    @rooted_device = rooted_device
    @user_country = user_country
    @user_ip = user_ip
  end

  def call
    user = User.find_by(idfa: idfa)

    unless user.present? && user.banned?
      valid_device = device_status.valid?
      user = User.find_or_create_by(idfa: idfa)

      unless valid_device
        user.update(ban_status: User::BANNED)
      end
    end

    user
  end

  private

  attr_reader :idfa, :rooted_device, :user_country, :user_ip

  def device_status
    ::DeviceStatusCheck.new(idfa, rooted_device, user_country, user_ip)
  end
end
