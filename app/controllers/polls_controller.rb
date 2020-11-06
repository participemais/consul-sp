class PollsController < ApplicationController
  include PollsHelper

  before_action :load_poll, except: [:index]
  before_action :load_active_poll, only: :index

  load_and_authorize_resource

  has_filters %w[current expired]
  has_orders %w[newest oldest], only: :show

  ::Poll::Answer # trigger autoload

  def index
    @polls = Kaminari.paginate_array(
      @polls.created_by_admin.not_budget.send(@current_filter).includes(:geozones).order(:starts_at)
    ).page(params[:page])
    @expired = @polls.select { |poll| poll.expired? }
  end

  def show
    @questions = @poll.questions.for_render.sort_for_list
    @token = poll_voter_token(@poll, current_user)
    @poll_questions_answers = Poll::Question::Answer.where(
      question: @poll.questions
    ).where.not(description: "").order(:given_order)

    @answers_by_question_id = ::Poll::Answer.answers_by_question_id(
      @poll.question_ids, current_user&.id
    )

    @commentable = @poll
    @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
  end

  def stats
    @stats = Poll::Stats.new(@poll)
  end

  def results
  end

  private

    def load_poll
      @poll = Poll.find_by_slug_or_id!(params[:id])
    end

    def load_active_poll
      @active_poll = ActivePoll.first
    end
end
