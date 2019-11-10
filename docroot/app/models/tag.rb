# frozen_string_literal: true

class Tag < ApplicationRecord
  include ByUser

  belongs_to :user
  has_many :taggings, dependent: :delete_all
  has_many :highlights, through: :taggings
  has_many :source_taggings, dependent: :delete_all
  has_many :sources, through: :source_taggings
  has_many :author_taggings, dependent: :delete_all
  has_many :authors, through: :author_taggings
  validates :user_id, numericality: { only_integer: true }
  validates_presence_of :title, message: "is required"

  # Filter tags by sources that have highlights with that tag.
  def self.by_source(id)
    self.joins("JOIN taggings ON taggings.tag_id = tags.id JOIN highlights ON highlights.id = taggings.highlight_id JOIN sources ON highlights.source_id = sources.id").where(highlights: { published: true }, sources: { id: id }).distinct
  end

  # Filter tags by authors that have sources that have highlights with that tag.
  def self.by_author(id)
    self.joins("JOIN taggings ON taggings.tag_id = tags.id JOIN highlights ON highlights.id = taggings.highlight_id JOIN sources ON highlights.source_id = sources.id JOIN sources_authors ON sources.id = sources_authors.source_id JOIN authors ON sources_authors.author_id = authors.id").where(highlights: { published: true }, authors: { id: id }).distinct
  end
end
