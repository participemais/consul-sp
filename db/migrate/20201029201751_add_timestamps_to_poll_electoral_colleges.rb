class AddTimestampsToPollElectoralColleges < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :poll_electoral_colleges
  end
end
