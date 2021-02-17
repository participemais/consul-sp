class CreateOpenGovPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :open_gov_plans do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :ends_at
      t.timestamps null: false
      t.string :video_url
    end
  end
end
