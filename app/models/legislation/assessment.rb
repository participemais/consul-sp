class Legislation::Assessment < ApplicationRecord
  belongs_to :evaluation,
    class_name: "Legislation::Evaluation",
    foreign_key: "legislation_evaluation_id",
    inverse_of: :assessments

  belongs_to :topic,
    class_name: "Legislation::Topic",
    foreign_key: "legislation_topic_id",
    inverse_of: :assessments

  has_many :topic_votes,
    class_name: "Legislation::TopicVote",
    foreign_key: "legislation_assessment_id",
    dependent: :destroy

  validates :title, presence: true
end
