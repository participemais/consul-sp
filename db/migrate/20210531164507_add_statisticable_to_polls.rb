class AddStatisticableToPolls < ActiveRecord::Migration[5.1]
  def change
    add_column :polls, :statisticable, :boolean
  end
end
