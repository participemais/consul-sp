class Budget::District < ApplicationRecord
  belongs_to :heading

  delegate :formal_jobs_by_population_reference_year,
  :slum_households_reference_year, to: :heading
end
