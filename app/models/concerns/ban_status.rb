module BanStatus
  BAN_STATUS = %w(banned not_banned)

  validates :ban_status, inclusion: { in: BAN_STATUS }
end
