class AddDateOfBirthToPollVoters < ActiveRecord::Migration[5.1]
  def change
    add_column :poll_voters, :date_of_birth, :datetime
  end
end
