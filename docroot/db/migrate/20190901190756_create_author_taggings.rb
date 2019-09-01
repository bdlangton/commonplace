class CreateAuthorTaggings < ActiveRecord::Migration[5.1]
  def change
    create_table :author_taggings do |t|
      t.bigint :author_id
      t.bigint :tag_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
