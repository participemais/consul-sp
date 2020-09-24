class AddAncestryToLegislationTopics < ActiveRecord::Migration[5.1]
  def change
    add_column :legislation_topics, :ancestry, :string
    add_index :legislation_topics, :ancestry
  end
end
