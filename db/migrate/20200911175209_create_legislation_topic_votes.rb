class CreateLegislationTopicVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :legislation_topic_votes do |t|
      t.references :legislation_topic, foreign_key: true
      t.references :legislation_assessment, foreign_key: true
      t.references :user, foreign_key: true
      t.text :comment
    end
  end
end
