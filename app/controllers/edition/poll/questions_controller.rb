class Edition::Poll::QuestionsController < Edition::Poll::BaseController
  include CommentableActions
  include Translatable

  load_and_authorize_resource :poll
  load_and_authorize_resource :question, class: "Poll::Question"

  before_action :authorize_editor

  def index
    @polls = Poll.not_budget
    @search = search_params[:search]

    @questions = @questions.search(search_params).page(params[:page]).order("created_at DESC")

    @proposals = Proposal.successful.sort_by_confidence_score
  end

  def new
    @polls = Poll.all
    proposal = Proposal.find(params[:proposal_id]) if params[:proposal_id].present?
    @question.copy_attributes_from_proposal(proposal)
  end

  def create
    @question.author = @question.proposal&.author || current_user

    if @question.save
      redirect_to edition_question_path(@question)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to edition_question_path(@question), notice: t("flash.actions.save_changes.notice")
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      notice = "Pergunta removida com sucesso"
    else
      notice = t("flash.actions.destroy.error")
    end
    redirect_to edition_poll_path(@question.poll), notice: notice
  end

  private

    def authorize_editor
      if current_user.editor?
        if current_user.editor.poll_ids.include?(params[:poll_id])
          return
        elsif action_name == 'destroy'
          raise CanCan::AccessDenied.new
        end
      end
    end

    def question_params
      attributes = [
        :poll_id, :question, :proposal_id, :category, :votes_per_question,
        :winners_amount
      ]
      params.require(:poll_question).permit(*attributes, translation_params(Poll::Question))
    end

    def search_params
      params.permit(:poll_id, :search)
    end

    def resource
      @poll_question ||= Poll::Question.find(params[:id])
    end
end
