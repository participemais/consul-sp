class CreateLegislationTopics < ActiveRecord::Migration[5.1]
  def change
    create_table :legislation_topics do |t|
      t.references :legislation_process, foreign_key: true
      t.references :legislation_topic_level, foreign_key: true
      t.string :title
      t.text :description
      t.integer :topic_votes_count, default: 0
      t.boolean :evaluable, default: false
    end
  end
end
