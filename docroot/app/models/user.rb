class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :authors, dependent: :destroy
  has_many :highlights, dependent: :destroy
  has_many :sources, dependent: :destroy
  has_many :tags, dependent: :destroy
end