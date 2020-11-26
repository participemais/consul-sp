class AddWinnersAmountToPollQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :poll_questions, :winners_amount, :integer, default: 1, null: false
  end
end
