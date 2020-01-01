# frozen_string_literal: true

module SourcesControllerConcern
  extend ActiveSupport::Concern

  # Get authors of the source, comma separated.
  def authors_comma_separated(source)
    authors = ""
    source.authors.each do |author|
      if authors.empty?
        authors = author.name
      else
        authors += ", " + author.name
      end
    end
    authors
  end
end
