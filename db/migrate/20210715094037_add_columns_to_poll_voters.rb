class AddColumnsToPollVoters < ActiveRecord::Migration[5.1]
  def change
    add_column :poll_voters, :city, :string
    add_column :poll_voters, :uf, :string
  end
end
