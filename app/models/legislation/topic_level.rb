class Legislation::TopicLevel < ApplicationRecord
  belongs_to :process,
    foreign_key: "legislation_process_id",
    inverse_of: :topic_levels

  has_many :legislation_topics,
    class_name: "Legislation::Topic",
    foreign_key: "legislation_topic_level_id",
    dependent: :destroy

  before_create :set_level

  delegate :topic_levels, to: :process

  def topic_level_label
    label = ''
    level.times { label << '1.' }
    label
  end

  def downcase_title
    title.downcase
  end

  private

  def set_level
    self.level = next_level
  end

  def next_level
    topic_levels.count + 1
  end
end
