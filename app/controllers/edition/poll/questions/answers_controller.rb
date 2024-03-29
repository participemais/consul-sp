class Edition::Poll::Questions::AnswersController < Edition::Poll::BaseController
  include Translatable

  before_action :load_answer, only: [:show, :edit, :update, :documents]

  load_and_authorize_resource :question, class: "::Poll::Question"

  before_action :authorize_editor

  def new
    @answer = ::Poll::Question::Answer.new
  end

  def create
    @answer = ::Poll::Question::Answer.new(answer_params)
    @question = @answer.question

    if @answer.save
      redirect_to edition_question_path(@question),
               notice: t("flash.actions.create.poll_question_answer")
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @answer.update(answer_params)
      redirect_to edition_question_path(@answer.question),
               notice: t("flash.actions.save_changes.notice")
    else
      render :edit
    end
  end

  def documents
    @documents = @answer.documents

    render "edition/poll/questions/answers/documents"
  end

  def order_answers
    ::Poll::Question::Answer.order_answers(params[:ordered_list])
    head :ok
  end

  private

    def authorize_editor
      if current_user.editor?
        if @question.present? && current_user.editor.poll_ids.include?(@question.poll.id)
          return
        elsif @answer.present? && current_user.editor.poll_ids.include?(@answer.question.poll.id)
          return
        else
          raise CanCan::AccessDenied.new
        end
      end
    end

    def answer_params
      documents_attributes = [:id, :title, :attachment, :cached_attachment, :user_id, :_destroy]
      attributes = [:title, :description, :given_order, :question_id,
        documents_attributes: documents_attributes]

      params.require(:poll_question_answer).permit(
        *attributes, translation_params(Poll::Question::Answer)
      )
    end

    def load_answer
      @answer = ::Poll::Question::Answer.find(params[:id] || params[:answer_id])
    end

    def resource
      load_answer unless @answer
      @answer
    end
end
