class User < ApplicationRecord
  has_many :expenses
  has_one :user_info, dependent: :destroy
  has_one :password

  validates :email, presence: true, uniqueness: true
end
