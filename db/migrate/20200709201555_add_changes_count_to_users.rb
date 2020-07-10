class AddChangesCountToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :document_number_changes_count, :integer
    add_column :users, :date_of_birth_changes_count, :integer
  end
end
