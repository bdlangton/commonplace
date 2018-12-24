class AddPublishedColumn < ActiveRecord::Migration[5.1]
  def change
    add_column :highlights, :published, :boolean, null: false, default: true
  end
end
