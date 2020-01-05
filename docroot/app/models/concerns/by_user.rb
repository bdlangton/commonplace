# frozen_string_literal: true

module ByUser
  extend ActiveSupport::Concern

  included do
    # Scope to filter by user ID.
    scope :by_user, ->(id) { where(user_id: id) }
  end
end
