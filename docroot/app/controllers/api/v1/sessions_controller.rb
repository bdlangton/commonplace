# frozen_string_literal: true

class Api::V1::SessionsController < Devise::SessionsController
  skip_before_action :verify_signed_out_user
  respond_to :json

  def create
    auth = auth_options.inspect
    params = params.inspect
    # render(status: 406, json: { message: auth }) && (return)
    unless request.format == :json
      sign_out
      render(status: 406,
               json: { message: "JSON requests only." }) && (return)
    end

    # auth_options should have `scope: :api_v1_user`
    resource = warden.authenticate!({ ":scope": "api_v1_user" })

    if resource.blank?
      render(status: 401,
               json: { response: "Access denied." }) && (return)
    end

    # render(status: 406, json: { message: resource.inspect }) && (return)
    sign_in(resource_name, resource)
    respond_with resource, location:
      after_sign_in_path_for(resource) do |format|
      format.json { render json:
                      { success: true,
                            jwt: current_token,
                       response: "Authentication successful"
                       }
                   }
    end
  end

  def destroy
    super && (return) if request.headers["Authorization"].blank?
    user = ApiUser.find_by_jti(decode_token)
    super && (return) if user.blank?
    revoke_token(user)
    super
  end

  private
    def decode_token
      token = request.headers["Authorization"].split("Bearer ").last
      secret = ENV["DEVISE_JWT_SECRET_KEY"]
      JWT.decode(token, secret, true, algorithm: "HS256",
                 verify_jti: true)[0]["jti"]
    end

    def revoke_token(user)
      user.update_column(:jti, generate_jti)
    end

    def current_token
      request.env["warden-jwt_auth.token"]
    end

    def generate_jti
      SecureRandom.uuid
    end
end
