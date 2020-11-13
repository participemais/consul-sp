class CreateFeasibilityAnalysisDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :feasibility_analysis_departments do |t|
      t.string :name
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
