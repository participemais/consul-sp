class CreateEditorPolls < ActiveRecord::Migration[5.1]
  def change
    create_table :editor_polls do |t|
    	t.references :editor, foreign_key: true
    	t.references :poll, foreign_key: true
    	
    	t.timestamps
    end
  end
end
