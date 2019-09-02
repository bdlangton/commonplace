class RemoveSourceAuthorsForeignKeys < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :sources_authors, column: :source_id
    remove_foreign_key :sources_authors, column: :author_id
  end
end
