class AddDepartmentIdToFeasibilityAnalyses < ActiveRecord::Migration[5.1]
  def change
    remove_column :feasibility_analyses, :responsible, :string
    add_reference :feasibility_analyses, :department, index: true
    add_foreign_key :feasibility_analyses, :feasibility_analysis_departments, column: :department_id
  end
end
