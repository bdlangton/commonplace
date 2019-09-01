class Tag < ApplicationRecord
  belongs_to :user
  has_many :taggings, :dependent => :delete_all
  has_many :highlights, through: :taggings
  has_many :source_taggings, :dependent => :delete_all
  has_many :sources, through: :source_taggings
  validates :user_id, numericality: { only_integer: true }

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }

  # Get a count of how many tags there are for a specific tag.
  def self.counts
    self.select("title, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
  end

  # Filter tags by sources that have highlights with that tag.
  def self.by_source(id)
    self.joins("JOIN taggings ON taggings.tag_id = tags.id JOIN highlights ON highlights.id = taggings.highlight_id JOIN sources ON highlights.source_id = sources.id").where(highlights: {published: true}, sources: {id: id}).distinct
  end

  # Filter tags by authors that have sources that have highlights with that tag.
  def self.by_author(id)
    self.joins("JOIN taggings ON taggings.tag_id = tags.id JOIN highlights ON highlights.id = taggings.highlight_id JOIN sources ON highlights.source_id = sources.id JOIN sources_authors ON sources.id = sources_authors.source_id JOIN authors ON sources_authors.author_id = authors.id").where(highlights: {published: true}, authors: {id: id}).distinct
  end
end
