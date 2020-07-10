class RenameSlumHouseholdsOnBudgetDistricts < ActiveRecord::Migration[5.1]
  def up
    change_column :budget_districts, :slum_households, :decimal
    rename_column :budget_districts, :slum_households, :slum_households_percentage
  end

  def down
    rename_column :budget_districts, :slum_households_percentage, :slum_households
    change_column :budget_districts, :slum_households, :integer
  end
end
