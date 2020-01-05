# frozen_string_literal: true

class RemoveTagsTaggableTable < ActiveRecord::Migration[5.1]
  def change
    drop_table :tags_taggable
    drop_table :taggings_taggable
  end
end
