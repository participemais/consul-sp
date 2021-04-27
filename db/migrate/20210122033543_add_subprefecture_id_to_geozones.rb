class AddSubprefectureIdToGeozones < ActiveRecord::Migration[5.1]
  def change
  	add_reference :geozones, :subprefecture, index: true
  end
end
