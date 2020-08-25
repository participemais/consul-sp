class FeasibilityAnalysis::Department < ApplicationRecord
  has_many :feasibility_analyses
  validates :name, presence: true
  validates :name, uniqueness: true
  scope :active, -> { where(active: true) }
  scope :sort_by_name, -> { order(name: :asc) }
end
