class AddMaxVotesAndBallotingTypeToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :max_votes, :integer
    add_column :budgets, :balloting_type, :string
  end
end
