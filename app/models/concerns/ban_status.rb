module BanStatus
  extend ActiveSupport::Concern

  BAN_STATUS = [
    BANNED = "banned",
    NOT_BANNED = "not_banned"
  ].freeze

  included do
    attribute :ban_status, default: -> { NOT_BANNED }
    validates :ban_status, inclusion: { in: BAN_STATUS }
  end

  BAN_STATUS.each do |status_name|
    define_method("#{status_name}?") do
      ban_status == status_name
    end
  end
end
