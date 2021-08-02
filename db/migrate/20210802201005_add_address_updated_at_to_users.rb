class AddAddressUpdatedAtToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :address_updated_at, :datetime
  end
end
