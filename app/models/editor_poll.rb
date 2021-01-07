class EditorPoll < ApplicationRecord
  belongs_to :editor
  belongs_to :poll
end