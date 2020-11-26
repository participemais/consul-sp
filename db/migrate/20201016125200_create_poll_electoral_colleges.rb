class CreatePollElectoralColleges < ActiveRecord::Migration[5.1]
  def change
    create_table :poll_electoral_colleges do |t|
      t.string :title
      t.boolean :active, default: true, null: false
      t.references :poll, foreign_key: true, index: true
    end
  end
end
