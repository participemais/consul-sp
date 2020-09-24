class CreateFeasibilityAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_table :feasibility_analyses, id: :serial do |t|
      t.string :technical, default: "undecided", limit: 15
      t.text :technical_description
      t.string :legal, default: "undecided", limit: 15
      t.text :legal_description
      t.string :budgetary, default: "undecided", limit: 15
      t.text :budgetary_description
      t.string :budgetary_actions
      t.string :sei_number
      t.string :responsible
      t.string :feasibility_analyzable_type
      t.integer :feasibility_analyzable_id

      t.timestamps null: false
    end
  end
end
