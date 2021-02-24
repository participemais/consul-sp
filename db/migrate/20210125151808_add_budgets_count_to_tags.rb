class AddBudgetsCountToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :budgets_count, :integer, default: 0
    add_index :tags, :budgets_count
  end
end
