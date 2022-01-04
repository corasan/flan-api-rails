class User < ApplicationRecord
  has_many :expenses
  has_one :user_info

  encrypts :password
  validates :password, presence: true, length: {
    minimum: 8,
    too_short: 'Password must be at least 8 characters long'
  }, on: :create
  validates :email, presence: true, uniqueness: true
end
