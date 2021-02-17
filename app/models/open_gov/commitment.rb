class OpenGov::Commitment < ApplicationRecord
	has_many :marks,
	  class_name: "OpenGov::Mark",
	  foreign_key: "open_gov_commitment_id",
	  dependent: :destroy
	belongs_to :plan,
	  class_name: "OpenGov::Plan",
	  foreign_key: "open_gov_plan_id"
end
