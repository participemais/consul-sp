class Legislation::TopicVote < ApplicationRecord
  belongs_to :assessment,
    foreign_key: "legislation_assessment_id",
    inverse_of: :topic_votes,
    counter_cache: true
  belongs_to :topic,
    foreign_key: "legislation_topic_id",
    inverse_of: :topic_votes,
    counter_cache: true
  belongs_to :user

  # def assessment_title
  delegate :title, to: :assessment, prefix: true

  delegate :username, to: :user, allow_nil: true

  scope :with_comment, -> { where.not(comment: [nil, ""]) }
end
