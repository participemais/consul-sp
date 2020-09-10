class Legislation::Assessment < ApplicationRecord
  belongs_to :legislation_topic
  belongs_to :legislation_evaluation

  validates :title, presence: true
end
