# frozen_string_literal: true

class AuthorTagging < ApplicationRecord
  belongs_to :author
  belongs_to :tag
end
