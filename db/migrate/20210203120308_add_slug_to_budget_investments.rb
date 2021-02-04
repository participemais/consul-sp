class AddSlugToBudgetInvestments < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_investments, :slug, :string
  end
end
