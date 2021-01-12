class OpenGov::Mark < ApplicationRecord
	has_many :lines, 
	  class_name: "OpenGov::Line",
	  foreign_key: "open_gov_mark_id",
	  dependent: :destroy
	belongs_to :commitment,
	  class_name: "OpenGov::Commitment",
	  foreign_key: "open_gov_commitment_id"
end
