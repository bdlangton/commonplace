# frozen_string_literal: true

class ApiUser < User
  include Devise::JWT::RevocationStrategies::JTIMatcher
  devise :database_authenticatable, :jwt_authenticatable, jwt_revocation_strategy: self
  validates :jti, presence: true

  def jwt_payload
    super
  end

  # SHould this be jwt_payload?
  def generate_jwt
    JWT.encode(
      {
        id: id,
        exp: 5.days.from_now.to_i
      },
      Rails.env.devise.jwt.secret_key
    )
  end
end
