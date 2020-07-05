class CreateBudgetDistricts < ActiveRecord::Migration[5.1]
  def change
    create_table :budget_districts do |t|
      t.string :name
      t.integer :population
      t.decimal :area
      t.integer :slum_households
      t.integer :extreme_poverty
      t.decimal :formal_jobs_by_population
      t.references :heading, index: true

      t.timestamps
    end
  end
end
