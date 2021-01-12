class OpenGov::Line < ApplicationRecord
	belongs_to :mark, 
	  class_name: "OpenGov::Mark",
	  foreign_key: "open_gov_mark_id"
end
