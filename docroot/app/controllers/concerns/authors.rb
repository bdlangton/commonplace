# frozen_string_literal: true

module Authors
  extend ActiveSupport::Concern

  # Get highlights count for an author.
  def author_highlights_count(author, favorites = false)
    @count = 0
    @sources = author.sources
    @sources.each do |source|
      if favorites
        @count += source.highlights.where(published: true, favorite: true).count
      else
        @count += source.highlights.where(published: true).count
      end
    end
    @count
  end
end
