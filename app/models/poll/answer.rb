class Poll::Answer < ApplicationRecord
  belongs_to :question, -> { with_hidden }, inverse_of: :answers
  belongs_to :author, ->   { with_hidden }, class_name: "User", inverse_of: :poll_answers

  delegate :poll, :poll_id, to: :question

  validates :question, presence: true
  validates :author, presence: true
  validates :answer, presence: true

  validates :answer, inclusion: { in: ->(a) { a.question.possible_answers }},
                     unless: ->(a) { a.question.blank? }

  scope :by_author, ->(author_id) { where(author_id: author_id) }
  scope :by_question, ->(question_id) { where(question_id: question_id) }

  def self.answers_by_question_id(question_ids, user_id)
    poll_answers = self.by_question(question_ids).by_author(user_id)
    poll_answers.inject({}) do |memo, answer|
      id, option = answer.question_id, answer.answer
      memo[id] ? memo[id] << option : memo[id] = [option]
      memo
    end
  end

  def record_voter_participation(token)
    Poll::Voter.find_or_create_by(user: author, poll: poll, origin: "web", token: token)
  end

  def destroy_voter_participation(token)
    Poll::Voter.find_by(
      user: author, poll: poll, origin: "web", token: token
    ).destroy
  end
end
