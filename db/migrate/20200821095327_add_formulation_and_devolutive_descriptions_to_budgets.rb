class AddFormulationAndDevolutiveDescriptionsToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :description_formulation, :text
    add_column :budgets, :description_devolutive, :text
  end
end
