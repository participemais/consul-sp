class Poll::Question::Answer::Exporter
  require "csv"

  def initialize(questions)
    @questions = questions
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ANSWER_COLUMNS.map { |column| answer_translation(column) }
      @questions.each do |question|
        question.answers.each do |answer|
          csv << csv_row(question, answer)
        end
        question.partial_results.each do |partial_result|
          partial_result.amount.times do
            csv << csv_row(question, partial_result)
          end
        end
      end
    end
  end

  private

  ANSWER_COLUMNS = %w(id origin question answer).freeze

  def csv_row(question, answer)
    [
      answer.id.to_s,
      vote_origin(answer),
      question.title,
      answer.answer
    ]
  end

  def answer_translation(key)
    I18n.t(key, scope: 'stats.polls.spreadsheet')
  end

  def vote_origin(answer)
    if answer.is_a?(Poll::PartialResult)
      answer_translation('booth')
    else
      answer_translation('web')
    end
  end
end
