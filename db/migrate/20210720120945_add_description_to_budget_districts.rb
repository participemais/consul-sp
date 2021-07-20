class AddDescriptionToBudgetDistricts < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_districts, :description, :text
  end
end
