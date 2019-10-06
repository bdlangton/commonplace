# frozen_string_literal: true

module SourcesHelper
  # Given a source, print out comma separated list of authors (links).
  def print_authors(source)
    source.authors.map { |author| link_to(author.name, author_path(author)) }.join(", ").html_safe
  end
end
