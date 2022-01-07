class RefreshToken < ApplicationRecord
  belongs_to :user
  encrypts :token, deterministic: true
end
