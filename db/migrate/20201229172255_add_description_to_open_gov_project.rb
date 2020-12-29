class AddDescriptionToOpenGovProject < ActiveRecord::Migration[5.1]
  def change
    add_column :open_gov_projects, :description, :string
    add_column :open_gov_projects, :link_text, :string
  end
end
