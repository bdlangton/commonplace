class RemoveFieldNameFromTableName < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :username
    remove_column :users, :password
  end
end
