class EditorLegislationProcess < ApplicationRecord
  belongs_to :editor
  belongs_to :process, class_name: "Legislation::Process"
end