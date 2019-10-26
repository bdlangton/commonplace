# frozen_string_literal: true

class HighlightSourceValidator < ActiveModel::Validator
  def validate(record)
    if record.user_id != record.source.user_id
      record.errors.add(record.source.title, "source isn't owned by the current user")
    end
  end
end
