# frozen_string_literal: true

class SourceAuthorValidator < ActiveModel::Validator
  def validate(record)
    record.authors.each do |author|
      if record.user_id != author.user_id
        record.errors.add(author.name, "author isn't owned by the current user")
      end
    end
  end
end
