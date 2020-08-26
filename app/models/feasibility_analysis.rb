class FeasibilityAnalysis < ApplicationRecord
  belongs_to :feasibility_analyzable, polymorphic: true
  belongs_to :department
  validates :feasibility_analyzable, presence: true
  validates :department_id, presence: true
  validates :department_id, uniqueness: { scope: :feasibility_analyzable_id }

  delegate :name, to: :department, prefix: true

  ANALYSES_FIELDS = %i(technical legal budgetary)

  def analysis_fields
    ANALYSES_FIELDS.reject { |field| send(field) == 'undecided' }
  end

  def should_show_codes?
    sei_number.present? || budgetary_actions.present?
  end
end
