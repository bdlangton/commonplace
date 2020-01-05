class AddFileToSources < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :file, :string
  end
end
