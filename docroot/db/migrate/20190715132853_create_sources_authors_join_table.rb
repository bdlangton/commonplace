class CreateSourcesAuthorsJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_table :sources_authors do |t|
      t.belongs_to :source, foreign_key: true
      t.belongs_to :author, foreign_key: true

      t.timestamps
    end
  end
end
