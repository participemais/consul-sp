class AddRegistrationDataToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :home_address, :string
    add_column :users, :address_number, :string
    add_column :users, :address_complement, :string
    add_column :users, :uf, :string
    add_column :users, :city, :string
    add_column :users, :cep, :string
    add_column :users, :ethnicity, :string
  end
end
