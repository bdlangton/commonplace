class Source < ApplicationRecord
  belongs_to :user
  has_many :highlights, :dependent => :delete_all
  validates :user_id, numericality: { only_integer: true }

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }
end
