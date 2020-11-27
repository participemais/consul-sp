class AddElectoralCollegeRestrictedToPolls < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :electoral_college_restricted, :boolean, default: false
  end
end
