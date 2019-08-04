class DropHighlightsTags < ActiveRecord::Migration[5.1]
  def up
    drop_table :highlights_tags
  end
end
