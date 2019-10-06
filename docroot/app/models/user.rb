# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :authors, dependent: :destroy
  has_many :highlights, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :tags, dependent: :destroy

  # Check if the user should receive daily emails.
  def self.receive_email(user)
    unless user.data.nil?
      data = JSON.parse(user.data)
      if data.include?("email") && data["email"].include?("receive")
        return data["email"]["receive"]
      end
    end
    false
  end

  # Check how many favorite highlights the user wants in their email.
  def self.email_favorite_count(user)
    unless user.data.nil?
      data = JSON.parse(user.data)
      if data.include?("email") && data["email"].include?("favorite_count")
        return data["email"]["favorite_count"].to_i
      end
    end
    2
  end

  # Check how many random highlights the user wants in their email.
  def self.email_random_count(user)
    unless user.data.nil?
      data = JSON.parse(user.data)
      if data.include?("email") && data["email"].include?("random_count")
        return data["email"]["random_count"].to_i
      end
    end
    1
  end
end
