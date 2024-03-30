class User < ApplicationRecord
  include BanStatus

  validates :idfa, presence: true, uniqueness: true

  before_save do
    cached_data = JSON.parse($redis.get(idfa), symbolize_names: true)

    if new_record? || ban_status_changed?
      IntegrityLog.create(
        idfa: idfa,
        ban_status: ban_status,
        ip: cached_data[:ip],
        rooted_device: cached_data[:rooted_device],
        country: cached_data[:country],
        proxy: cached_data[:security][:proxy],
        vpn: cached_data[:security][:vpn]
      )
    end
  end
end
