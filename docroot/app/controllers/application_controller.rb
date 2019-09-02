# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::API
  respond_to :json
  protect_from_forgery with: :null_session
end
