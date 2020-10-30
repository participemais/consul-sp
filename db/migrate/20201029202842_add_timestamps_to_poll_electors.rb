class AddTimestampsToPollElectors < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :poll_electors
  end
end
