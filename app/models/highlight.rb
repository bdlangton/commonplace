class Highlight < ApplicationRecord
  belongs_to :user
  belongs_to :source
  has_many :taggings, :dependent => :delete_all
  has_many :tags, through: :taggings
  validates_numericality_of :user_id, :equal_to => Proc.new { |highlight| highlight.source.user_id }
  validates :user_id, numericality: { only_integer: true }
  validates :source_id, numericality: { only_integer: true }

  # Scope to filter by user ID.
  scope :by_user, ->(id) { where(user_id: id) }

  # Find or create each of the tags from the comma separated list.
  def all_tags=(titles)
    # Reject any 'blank' entries between commas.
    titles = titles.split(",").reject(&:blank?)
    self.tags = titles.map do |title|
      Tag.where(title: title.strip, user_id: user_id).first_or_create!
    end
  end

  # Display all tags as comma separated.
  def all_tags
    self.tags.map(&:title).join(", ")
  end

  # Find highlights tagged with the tag.
  def self.tagged_with(titles)
    if titles.kind_of?(Array)
      titles.each do |title|
        if @highlights.nil?
          @highlights = Tag.find_by_title!(title).highlights
        else
          @highlights += Tag.find_by_title!(title).highlights
        end
      end
    else
      @highlights = Tag.find_by_title!(titles).highlights.to_a
    end
    return @highlights.uniq
  end

end
