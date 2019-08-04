class AddFavoriteToHighlights < ActiveRecord::Migration[5.1]
  def change
    add_column :highlights, :favorite, :boolean
  end
end
