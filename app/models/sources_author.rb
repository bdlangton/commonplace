class SourcesAuthor < ApplicationRecord
  belongs_to :source
  belongs_to :author
end
