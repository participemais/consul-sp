class RemoveUnfeasibleEmailSentAtFromBudgetInvestments < ActiveRecord::Migration[5.1]
  def change
    remove_column :budget_investments, :unfeasible_email_sent_at, :datetime
  end
end
