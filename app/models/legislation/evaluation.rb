class Legislation::Evaluation < ApplicationRecord
  belongs_to :legislation_topic_level

  validates :title, presence: true
end
