class CreateHighlightsTagsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :highlights, :tags
  end
end
