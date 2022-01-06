class User < ApplicationRecord
  has_many :expenses
  has_one :user_info, dependent: :destroy
  has_one :password
  has_one :refresh_token

  validates :email, presence: true, uniqueness: true
end
