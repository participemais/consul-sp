class CreateOpenGovLine < ActiveRecord::Migration[5.1]
  def change
    create_table :open_gov_lines do |t|
      t.string :title
      t.string :author
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :status
      t.references :open_gov_mark, foreign_key: true, index: true
    end
  end
end
