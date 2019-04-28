class ChangeIdColumns < ActiveRecord::Migration[5.1]
  def change
    change_column :highlights, :user_id, :bigint
    change_column :sources, :user_id, :bigint
    change_column :tags, :user_id, :bigint
    change_column :taggings, :highlight_id, :bigint
    change_column :taggings, :tag_id, :bigint
  end
end
