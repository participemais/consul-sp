class Legislation::Topic::Exporter
  include LegislationTopicsHelper
  require "csv"

  def initialize(root_topics)
    @root_topics = root_topics
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << TOPIC_COLUMNS.map { |column| header_translation(column) }
      counter_level = 1
      @root_topics.each.with_index(1) do |topic, index|
        indexes = [index]

        topic.topic_votes.each do |topic_vote|
          csv << csv_row(topic, topic_vote, indexes)
        end

        topic_values(csv, topic, counter_level, indexes)
      end
    end
  end

  private

  TOPIC_COLUMNS = %w(
    id topic_level_label title description assessment comment user
  ).freeze

  def csv_row(topic, topic_vote, indexes)
    row = [
      topic_vote.id.to_s,
      topic_level_label(indexes),
      topic.title,
      topic.description,
      topic_vote.assessment_title
    ]

    if topic_vote.comment.present?
      row += [topic_vote.comment, topic_vote.username]
    end

    row
  end

  def topic_values(csv, topic, counter_level, indexes)
    counter_level += 1
    topic.ordered_children.each.with_index(1) do |child, index|
      indexes = topic_indexes(indexes, index, counter_level)

      child.topic_votes.each do |topic_vote|
        csv << csv_row(child, topic_vote, indexes)
      end

      if child.children.any?
        topic_values(csv, child, counter_level, indexes)
      end
    end
  end

  def header_translation(key)
    I18n.t(key, scope: 'legislation.topics.spreadsheet')
  end
end
