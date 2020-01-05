# frozen_string_literal: true

class HighlightTagValidator < ActiveModel::Validator
  def validate(record)
    record.tags.each do |tag|
      if record.user_id != tag.user_id
        record.errors.add(tag.title, "tag isn't owned by the current user")
      end
    end
  end
end
