class CreateLegislationEvaluations < ActiveRecord::Migration[5.1]
  def change
    create_table :legislation_evaluations do |t|
      t.references :legislation_topic_level, foreign_key: true
      t.string :title
    end
  end
end
