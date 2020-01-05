# frozen_string_literal: true

class SourcesAuthor < ApplicationRecord
  belongs_to :source
  belongs_to :author
end
