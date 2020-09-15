class Legislation::Topic < ApplicationRecord
  has_ancestry

  belongs_to :process,
    foreign_key: "legislation_process_id",
    inverse_of: :topics

  belongs_to :legislation_topic_level, class_name: "Legislation::TopicLevel"

  has_many :assessments,
    class_name: "Legislation::Assessment",
    foreign_key: "legislation_topic_id",
    dependent: :destroy

  has_many :topic_votes,
    class_name: "Legislation::TopicVote",
    foreign_key: "legislation_topic_id",
    dependent: :destroy

  validates :title, presence: true

  before_save :copy_evaluations, if: :evaluable

  def topic_vote_for_user(user)
    topic_votes.find_by(user: user)
  end

  private

  def copy_evaluations
    return if assessments.any?
    legislation_topic_level.evaluations.each do |evaluation|
      self.assessments.build(
        legislation_evaluation_id: evaluation.id,
        title: evaluation.title
      )
    end
  end

end
