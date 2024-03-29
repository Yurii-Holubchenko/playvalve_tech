class User < ApplicationRecord
  include BanStatus

  validates :idfa, presence: true, uniqueness: true
end
