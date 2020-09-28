class CreateLegislationAssessments < ActiveRecord::Migration[5.1]
  def change
    create_table :legislation_assessments do |t|
      t.references :legislation_topic, foreign_key: true
      t.references :legislation_evaluation, foreign_key: true
      t.string :title
      t.integer :topic_votes_count, default: 0
    end
  end
end
