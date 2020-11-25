class Legislation::Debate::Exporter
  require "csv"

  def initialize(questions)
    @questions = questions
  end

  def answers_csv
    CSV.generate(headers: true) do |csv|
      csv << ANSWER_COLUMNS.map { |column| header_translation(column) }

      @questions.each do |question|
        question.answers.each do |answer|
          csv << answer_csv_row(question, answer)
        end
      end
    end
  end

  def comments_csv
    CSV.generate(headers: true) do |csv|
      csv << COMMENT_COLUMNS.map { |column| header_translation(column) }

      @questions.each do |question|
        question.comments.each do |answer|
          csv << comment_csv_row(question, answer)
        end
      end
    end
  end

  private

  ANSWER_COLUMNS = %w(id question_title answer).freeze
  COMMENT_COLUMNS = %w(id question_title answer user).freeze

  def answer_csv_row(question, answer)
    [
      answer.id.to_s,
      question.title,
      answer.question_option.value
    ]
  end

  def comment_csv_row(question, comment)
    [
      comment.id.to_s,
      question.title,
      comment.body,
      comment.username
    ]
  end

  def header_translation(key)
    I18n.t(key, scope: 'legislation.questions.spreadsheet')
  end
end
