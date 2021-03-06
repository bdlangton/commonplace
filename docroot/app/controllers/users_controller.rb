# frozen_string_literal: true

# Users controller.
class UsersController < ApplicationController
  # User settings.
  def settings
    @user = current_user
  end

  # Update user profile.
  def update
    current_user.data = {
      "email" => {
        "receive" => params[:user][:receive] ? true : false,
        "summary_count" => params[:user][:summary_count],
        "favorite_count" => params[:user][:favorite_count],
        "random_count" => params[:user][:random_count]
      }
    }.to_json

    if current_user.save
      redirect_to "/"
    else
      render "settings"
    end
  end
end
