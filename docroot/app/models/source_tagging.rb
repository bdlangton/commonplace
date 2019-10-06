# frozen_string_literal: true

class SourceTagging < ApplicationRecord
  belongs_to :source
  belongs_to :tag
end
