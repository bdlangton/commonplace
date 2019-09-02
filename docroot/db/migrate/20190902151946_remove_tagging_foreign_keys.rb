class RemoveTaggingForeignKeys < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :taggings, column: :highlight_id
    remove_foreign_key :taggings, column: :tag_id
  end
end
