class Tagging < ApplicationRecord
  belongs_to :highlight
  belongs_to :tag
end
