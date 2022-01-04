class Password < ApplicationRecord
  belongs_to :user
  encrypts :value
  encrypts :user_id, deterministic: true

  validates :value, presence: true, length: {
    minimum: 8,
    too_short: 'Password must be at least 8 characters long'
  }, on: %i[create update]
end
