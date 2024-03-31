class User < ApplicationRecord
  include BanStatus

  validates :idfa, presence: true, uniqueness: true

  before_save do
    redis_response = $redis.get(idfa) || {}.to_json
    cached_data = JSON.parse(redis_response, symbolize_names: true)

    if new_record? || ban_status_changed?
      IntegrityLog.create(
        idfa: idfa,
        ban_status: ban_status,
        ip: cached_data.fetch(:ip, ""),
        rooted_device: cached_data.dig(:rooted_device),
        country: cached_data.fetch(:country, ""),
        proxy: cached_data.dig(:security, :proxy),
        vpn: cached_data.dig(:security, :vpn)
      )
    end
  end
end
