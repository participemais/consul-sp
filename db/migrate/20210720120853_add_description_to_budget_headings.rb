class AddDescriptionToBudgetHeadings < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_headings, :description, :text
  end
end
