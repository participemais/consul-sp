class AddStatisticsToBudgetHeadings < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_headings, :households, :integer
    add_column :budget_headings, :hdi, :decimal
    add_column :budget_headings, :hdi_reference_year, :integer
    add_column :budget_headings, :population_density, :decimal
    add_column :budget_headings, :population_density_reference_year, :integer
    add_column :budget_headings, :analytical_framework_url, :string
    add_column :budget_headings, :action_perimeter_url, :string
  end
end
