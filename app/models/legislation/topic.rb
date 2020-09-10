class Legislation::Topic < ApplicationRecord
  has_ancestry

  belongs_to :process,
    foreign_key: "legislation_process_id",
    inverse_of: :topics

  belongs_to :legislation_topic_level, class_name: "Legislation::TopicLevel"

  has_many :assessments,
    class_name: "Legislation::Assessment",
    foreign_key: "legislation_topics_id",
    dependent: :destroy

  validates :title, presence: true

  before_save :copy_evaluations, if: :evaluable

  private

  def copy_evaluations
    return if assessments.any?
    legislation_topic_level.evaluations.each do |evaluation|
      self.assessments.build(title: evaluation.title)
    end
  end

end
