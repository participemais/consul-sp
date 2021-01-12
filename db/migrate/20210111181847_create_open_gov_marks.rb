class CreateOpenGovMarks < ActiveRecord::Migration[5.1]
  def change
    create_table :open_gov_marks do |t|
      t.string :title
      t.string :author
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :status
      t.references :open_gov_commitment, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end
