class CreateSources < ActiveRecord::Migration[5.1]
  def change
    create_table :sources do |t|
      t.string :title
      t.string :author
      t.string :source_type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
