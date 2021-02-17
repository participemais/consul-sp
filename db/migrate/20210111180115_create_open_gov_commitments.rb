class CreateOpenGovCommitments < ActiveRecord::Migration[5.1]
  def change
    create_table :open_gov_commitments do |t|
      t.string :title
      t.string :coordenation
      t.text :work_group
      t.datetime :starts_at
      t.datetime :ends_at
      t.references :open_gov_plan, foreign_key: true, index: true
      t.timestamps null: false
    end
  end
end
