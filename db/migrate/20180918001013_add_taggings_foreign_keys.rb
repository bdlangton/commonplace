class AddTaggingsForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key "taggings", "Highlights", column: "highlight_id"
    add_foreign_key "taggings", "Tags", column: "tag_id"
  end
end
