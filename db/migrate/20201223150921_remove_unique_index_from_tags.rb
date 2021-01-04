class RemoveUniqueIndexFromTags < ActiveRecord::Migration[5.1]
  def change
    remove_index :tags, :name
  end
end
