class AddAsinToSource < ActiveRecord::Migration[5.1]
  def change
    add_column :sources, :asin, :string
  end
end
