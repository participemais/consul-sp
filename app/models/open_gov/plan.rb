class OpenGov::Plan < ApplicationRecord
  include Documentable
  include Milestoneable
	
  has_many :commitments, 
	class_name: "OpenGov::Commitment",
	foreign_key: "open_gov_plan_id",
	dependent: :destroy

  accepts_nested_attributes_for :documents, allow_destroy: true

  scope :current, -> { where("starts_at <= ? and ends_at >= ?", Date.current, Date.current).last }
end
