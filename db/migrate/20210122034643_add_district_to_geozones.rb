class AddDistrictToGeozones < ActiveRecord::Migration[5.1]
  def change
    add_column :geozones, :district, :boolean
  end
end
