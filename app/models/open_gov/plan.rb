class OpenGov::Plan < ApplicationRecord
  include Documentable
	
  has_many :commitments, 
	class_name: "OpenGov::Commitment",
	foreign_key: "open_gov_plan_id",
	dependent: :destroy

  accepts_nested_attributes_for :documents, allow_destroy: true
end
