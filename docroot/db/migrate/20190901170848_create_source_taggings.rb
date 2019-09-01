class CreateSourceTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :source_taggings do |t|
      t.bigint :source_id
      t.bigint :tag_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
