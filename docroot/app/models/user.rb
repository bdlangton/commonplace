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
  validates_presence_of :email, message: "is required"
  validates_uniqueness_of :email, message: "There is already an account with that email."

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

  # Check how many highlights the user wants in their email.
  # Type can be favorites or random.
  def self.email_count(user, type = "favorite")
    unless user.data.nil?
      data = JSON.parse(user.data)
      if data.include?("email") && data["email"].include?(type + "_count")
        return data["email"][type + "_count"].to_i
      end
    end
    1
  end
end
