# frozen_string_literal: true

class Highlight < ApplicationRecord
  include Authors
  include ByUser
  include Tags

  belongs_to :user
  belongs_to :source
  has_many :taggings, dependent: :delete_all
  has_many :tags, through: :taggings
  validates_numericality_of :user_id, equal_to: Proc.new { |highlight|
    highlight.source.user_id.nil? ? 0 : highlight.source.user_id
  }
  validates :user_id, numericality: { only_integer: true }
  validates :source_id, numericality: { only_integer: true }
  validates_with HighlightSourceValidator
  validates_with HighlightTagValidator
  validates_presence_of :highlight, message: "is required"

  # Find highlights tagged with the tag.
  def self.tagged_with(titles)
    if titles.kind_of?(Array)
      @highlights = []
      titles.each do |title|
        @highlights += Tag.find_by_title!(title).highlights
      end
    else
      @highlights = Tag.find_by_title!(titles).highlights.to_a
    end
    @highlights.uniq
  rescue ActiveRecord::RecordNotFound
    []
  end

  # Filter highlights by authors that have sources that have those highlights.
  def self.by_author(id)
    self.joins("JOIN sources ON highlights.source_id = sources.id JOIN sources_authors ON sources.id = sources_authors.source_id").where(highlights: { published: true }, sources_authors: { author_id: id }).distinct
  end
end
