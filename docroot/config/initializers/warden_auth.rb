# frozen_string_literal: true

# config/initializers/warden_auth.rb
Warden::JWTAuth.configure do |config|
  config.secret = ENV["DEVISE_JWT_SECRET_KEY"]
  config.dispatch_requests = [
                               ["POST", %r{^/api/v1/login$}],
                               ["POST", %r{^/api/v1/login.json$}]
                             ]
  config.revocation_requests = [
                                 ["DELETE", %r{^/api/v1/logout$}],
                                 ["DELETE", %r{^/api/v1/logout.json$}]
                               ]
end
