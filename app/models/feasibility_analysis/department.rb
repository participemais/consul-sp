class FeasibilityAnalysis::Department < ApplicationRecord
  has_many :feasibility_analyses
  validates :name, presence: true
  validates :name, uniqueness: true
end
