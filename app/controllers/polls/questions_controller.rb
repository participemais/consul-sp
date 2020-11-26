class Polls::QuestionsController < ApplicationController
  load_and_authorize_resource :poll
  load_and_authorize_resource :question, class: "Poll::Question"

  has_orders %w[newest oldest], only: :show

  def answer
    answer = @question.answers.new(
      author: current_user, answer: params[:answer]
    )

    answer.save!
    answer.record_voter_participation(params[:token])

    @answers_by_question_id = {
      @question.id => @question.user_answers_choices(current_user)
    }
  end

  def destroy_answer
    answer = @question.answers.find_by(
      author: current_user, answer: params[:answer]
    )

    if @poll.last_user_answer?(current_user)
      answer.destroy_voter_participation(params[:token])
    end

    answer.destroy!

    @answers_by_question_id = {
      @question.id => @question.user_answers_choices(current_user)
    }
  end
end
