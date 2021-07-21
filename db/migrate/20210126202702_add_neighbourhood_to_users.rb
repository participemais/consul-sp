class AddNeighbourhoodToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :neighbourhood, :string
  end
end
