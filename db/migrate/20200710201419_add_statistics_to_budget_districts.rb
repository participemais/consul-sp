class AddStatisticsToBudgetDistricts < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_districts, :households, :integer
    add_column :budget_districts, :population_density, :decimal
  end
end
