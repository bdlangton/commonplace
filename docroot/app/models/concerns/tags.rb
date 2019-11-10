# frozen_string_literal: true

module Tags
  extend ActiveSupport::Concern

  # Find or create each of the tags from the comma separated list.
  def all_tags=(tags_and_user)
    # Break out the comma separated tag titles from the user ID.
    titles = tags_and_user[0]
    user_id = tags_and_user[1]

    if titles.present?
      # Reject any 'blank' entries between commas.
      titles = titles.split(",").reject(&:blank?)
      self.tags = titles.map do |title|
        Tag.where(title: title.strip, user_id: user_id).first_or_create!
      end
    end
  end

  # Display all tags as comma separated.
  def all_tags
    self.tags.map(&:title).join(", ")
  end
end
