class Highlight < ApplicationRecord
  belongs_to :user
  belongs_to :source
  has_many :taggings, :dependent => :delete_all
  has_many :tags, through: :taggings

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }

  # Find or create each of the tags from the comma separated list.
  def all_tags=(titles)
    self.tags = titles.split(",").map do |title|
      Tag.where(title: title.strip, user: 1).first_or_create!
    end
  end

  # Display all tags as comma separated.
  def all_tags
    self.tags.map(&:title).join(", ")
  end

  # Find highlights tagged with the tag.
  def self.tagged_with(title)
    Tag.find_by_title!(title).highlights
  end
end
