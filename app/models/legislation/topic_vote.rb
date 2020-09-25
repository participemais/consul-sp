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
end
