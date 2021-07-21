class CreateGeozonesForStatsPolls < ActiveRecord::Migration[5.1]
  def change
    create_table :geozones_for_stats_polls do |t|
    	t.references :geozone, index: true
      t.references :poll, index: true

      t.timestamps
    end
  end
end
