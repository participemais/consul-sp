class AddEraseReasonDescriptionToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :erase_reason_description, :string
  end
end
