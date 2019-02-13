class ChangeDefaultValueLocation < ActiveRecord::Migration[5.1]
  def change
    change_column :highlights, :location, :int, :default => 0
  end
end
