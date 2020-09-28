class AddTopicsPhaseToLegislationProcesses < ActiveRecord::Migration[5.1]
  def change
    add_column :legislation_processes, :topics_phase_start_date, :date
    add_index :legislation_processes, :topics_phase_start_date
    add_column :legislation_processes, :topics_phase_end_date, :date
    add_index :legislation_processes, :topics_phase_end_date
    add_column :legislation_processes, :topics_phase_enabled, :boolean
  end
end
