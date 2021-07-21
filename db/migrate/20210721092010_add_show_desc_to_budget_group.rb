class AddShowDescToBudgetGroup < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_groups, :show_description, :boolean
  end
end
