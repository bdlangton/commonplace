class Source < ApplicationRecord
  belongs_to :user
  has_many :highlights, :dependent => :delete_all
end
