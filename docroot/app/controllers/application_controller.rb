# frozen_string_literal: true

# Application controller.
class ApplicationController < ActionController::Base
  respond_to :json, :html
  protect_from_forgery with: :null_session
  before_action :authenticate_user!
end
