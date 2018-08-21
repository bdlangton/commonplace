class Tag < ApplicationRecord
  belongs_to :user
  has_many :taggings, :dependent => :delete_all
  has_many :highlights, through: :taggings

  def self.counts
    self.select("title, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
  end
end
