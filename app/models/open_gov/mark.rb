class OpenGov::Mark < ApplicationRecord
  include Documentable

  has_many :lines,
    class_name: "OpenGov::Line",
    foreign_key: "open_gov_mark_id",
    dependent: :destroy

  belongs_to :commitment,
    class_name: "OpenGov::Commitment",
    foreign_key: "open_gov_commitment_id"

  accepts_nested_attributes_for :documents, allow_destroy: true
end
