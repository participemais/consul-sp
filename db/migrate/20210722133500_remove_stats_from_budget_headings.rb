class RemoveStatsFromBudgetHeadings < ActiveRecord::Migration[5.1]
  def change
    remove_column :budget_headings, :area, :decimal
    remove_column :budget_headings, :population, :integer
  end
end
