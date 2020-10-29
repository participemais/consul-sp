class CreatePollElectors < ActiveRecord::Migration[5.1]
  def change
    create_table :poll_electors do |t|
      t.string :document_type
      t.string :document_number
      t.string :category
      t.boolean :user_found, default: false, null: false
      t.references :poll_electoral_college, foreign_key: true, index: true
      t.references :user, foreign_key: true, index: true
    end
  end
end
