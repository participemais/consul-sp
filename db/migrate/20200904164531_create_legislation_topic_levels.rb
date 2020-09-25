class CreateLegislationTopicLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :legislation_topic_levels do |t|
      t.string :title
      t.integer :level
      t.references :legislation_process, foreign_key: true
    end
  end
end
