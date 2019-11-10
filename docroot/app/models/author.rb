# frozen_string_literal: true

class Author < ApplicationRecord
  include Authors
  include ByUser
  include Tags

  belongs_to :user
  has_many :sources_authors, dependent: :delete_all
  has_many :sources, through: :sources_authors
  has_many :author_taggings, dependent: :delete_all
  has_many :tags, through: :author_taggings
  validates :user_id, numericality: { only_integer: true }
  validates_presence_of :name, message: "is required"
end
