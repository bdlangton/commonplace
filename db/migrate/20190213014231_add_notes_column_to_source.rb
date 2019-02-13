class AddNotesColumnToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :notes, :text
  end
end
