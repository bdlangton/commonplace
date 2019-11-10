# frozen_string_literal: true

module Authors
  extend ActiveSupport::Concern

  # Find or create each of the tags from the comma separated list.
  def all_authors=(authors_and_user)
    # Break out the comma separated tag titles from the user ID.
    authors = authors_and_user[0]
    user_id = authors_and_user[1]

    if authors.present?
      # Reject any 'blank' entries between commas.
      authors = authors.split(",").reject(&:blank?)
      self.authors = authors.map do |author|
        Author.where(name: author.strip, user_id: user_id).first_or_create!
      end
    end
  end

  # Display all authors as comma separated.
  def all_authors
    self.authors.map(&:name).join(", ")
  end
end

