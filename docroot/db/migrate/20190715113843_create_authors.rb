class CreateAuthors < ActiveRecord::Migration[5.1]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :type
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
