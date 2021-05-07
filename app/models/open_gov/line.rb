class OpenGov::Line < ApplicationRecord
  include Documentable
  belongs_to :mark,
    class_name: "OpenGov::Mark",
	foreign_key: "open_gov_mark_id"

  accepts_nested_attributes_for :documents, allow_destroy: true

end
