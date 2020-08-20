class FeasibilityAnalysis < ApplicationRecord
  belongs_to :feasibility_analyzable, polymorphic: true
  validates :feasibility_analyzable, presence: true
  validates :responsible, presence: true
  validates :responsible, uniqueness: { scope: :feasibility_analyzable_id }
end
