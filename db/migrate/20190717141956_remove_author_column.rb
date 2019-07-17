class RemoveAuthorColumn < ActiveRecord::Migration[5.1]
  def change
    # Remove old author column.
    remove_column :sources, :author
  end
end
