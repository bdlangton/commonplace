class CreateHighlights < ActiveRecord::Migration[5.1]
  def change
    create_table :highlights do |t|
      t.text :highlight
      t.text :note
      t.references :user, foreign_key: true
      t.references :source, foreign_key: true

      t.timestamps
    end
  end
end
