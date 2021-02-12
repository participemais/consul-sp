class OpenGov::Plan < ApplicationRecord
  include Documentable
  include Milestoneable
	
  has_many :commitments, 
	class_name: "OpenGov::Commitment",
	foreign_key: "open_gov_plan_id",
	dependent: :destroy

  accepts_nested_attributes_for :documents, allow_destroy: true

  def current?
    starts_at <= Date.current && ends_at >= Date.current
  end
end
