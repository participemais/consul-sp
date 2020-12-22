class CreateOpenGovProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :open_gov_projects do |t|
      t.string :title
      t.string :link_url
    end
  end
end
