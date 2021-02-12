class AddCodeToBudgetInvestments < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_investments, :code, :integer
  end
end
