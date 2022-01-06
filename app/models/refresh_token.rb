class RefreshToken < ApplicationRecord
  belongs_to :user
  encrypts :token, deterministic: true
  # encrypts :user_id, deterministic: true
end
