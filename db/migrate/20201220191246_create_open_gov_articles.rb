class CreateOpenGovArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :open_gov_articles, id: :serial do |t|
      t.string :title
      t.text :text
      t.integer :author_id, index: true
      t.timestamps null: false
    end
  end
end
