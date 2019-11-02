# frozen_string_literal: true

class Source < ApplicationRecord
  include Authors
  include Tags

  belongs_to :user
  has_many :highlights, dependent: :delete_all
  has_many :sources_authors, dependent: :delete_all
  has_many :authors, through: :sources_authors
  has_many :source_taggings, dependent: :delete_all
  has_many :tags, through: :source_taggings
  validates :user_id, numericality: { only_integer: true }
  validates_with SourceAuthorValidator
  validates_presence_of :title, message: "is required"
  validates_presence_of :authors, message: "is required"
  validates_presence_of :source_type, message: "is required"

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }
end
