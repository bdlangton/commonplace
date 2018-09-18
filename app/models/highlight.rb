class Highlight < ApplicationRecord
  belongs_to :user
  belongs_to :source
  has_many :taggings, :dependent => :delete_all
  has_many :tags, through: :taggings

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }

  def all_tags=(titles)
    self.tags = titles.split(",").map do |title|
      Tag.where(title: title.strip, user: 1).first_or_create!
    end
  end

  def all_tags
    self.tags.map(&:title).join(", ")
  end

  def self.tagged_with(title)
    Tag.find_by_title!(title).highlights
  end
end
