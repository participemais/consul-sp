class Legislation::Evaluation < ApplicationRecord
  belongs_to :legislation_topic_level

  has_many :legislation_assessments,
    class_name: "Legislation::Assessment",
    foreign_key: "legislation_evaluation_id"

  validates :title, presence: true

  before_update :update_assessments, if: :title_changed?

  private

  def update_assessments
    legislation_assessments.update_all(title: title)
  end
end
