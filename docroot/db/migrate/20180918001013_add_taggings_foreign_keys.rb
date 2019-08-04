class AddTaggingsForeignKeys < ActiveRecord::Migration[5.1]
  def change
    add_foreign_key "taggings", "highlights", column: "highlight_id"
    add_foreign_key "taggings", "tags", column: "tag_id"
  end
end
