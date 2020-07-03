class AddSocialIndexesToBudgetHeadings < ActiveRecord::Migration[5.1]
  def change
    add_column :budget_headings, :area, :decimal
    add_column :budget_headings, :slum_households, :integer
    add_column :budget_headings, :slum_households_reference_year, :integer
    add_column :budget_headings, :extreme_poverty, :integer
    add_column :budget_headings, :extreme_poverty_reference_year, :integer
    add_column :budget_headings, :formal_jobs_by_population, :decimal
    add_column :budget_headings, :formal_jobs_by_population_reference_year, :integer
  end
end
