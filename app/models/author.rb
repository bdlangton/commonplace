class Author < ApplicationRecord
  belongs_to :user
  has_many :sources_authors, :dependent => :delete_all
  has_many :sources, through: :sources_authors
  validates :user_id, numericality: { only_integer: true }

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }
end
