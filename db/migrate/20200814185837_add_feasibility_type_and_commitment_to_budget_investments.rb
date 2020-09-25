class AddFeasibilityTypeAndCommitmentToBudgetInvestments < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_investments, :feasibility_type, :string
    add_column :budget_investments, :commitment, :text
  end
end
