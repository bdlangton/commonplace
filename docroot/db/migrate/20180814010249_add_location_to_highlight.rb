class AddLocationToHighlight < ActiveRecord::Migration[5.1]
  def change
    add_column :highlights, :location, :integer
  end
end
