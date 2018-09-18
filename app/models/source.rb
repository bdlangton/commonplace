class Source < ApplicationRecord
  belongs_to :user
  has_many :highlights, :dependent => :delete_all

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }
end
