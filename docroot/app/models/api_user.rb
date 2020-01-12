# frozen_string_literal: true

class ApiUser < User
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  self.skip_session_storage = [:http_auth, :params_auth]

  before_create :add_jti

  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def jwt_payload
    super.merge("foo" => "bar")
  end
end
