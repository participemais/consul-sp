module FeasibilityAnalyzable
  extend ActiveSupport::Concern

  included do
    has_many :feasibility_analyses,
      as: :feasibility_analyzable,
      inverse_of: :feasibility_analyzable,
      dependent: :destroy
  end
end
