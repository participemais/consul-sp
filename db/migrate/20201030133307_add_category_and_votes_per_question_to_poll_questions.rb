class AddCategoryAndVotesPerQuestionToPollQuestions < ActiveRecord::Migration[5.1]
  def change
    add_column :poll_questions, :category, :string
    add_column :poll_questions, :votes_per_question, :integer, default: 1, null: false
  end
end
