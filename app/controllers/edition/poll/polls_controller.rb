class Edition::Poll::PollsController < Edition::Poll::BaseController
  include Translatable
  include ImageAttributes
  include ReportAttributes
  load_and_authorize_resource

  before_action :block_edition, except: [:index, :booth_assignments]
  before_action :load_search, only: [:search_booths, :search_officers]
  before_action :load_geozones, only: [:new, :create, :edit, :update], if: :is_admin?

  def index
    if is_admin?
      @polls = Poll.not_budget.created_by_admin.order(starts_at: :desc)
    else
      @polls = Poll.not_budget.created_by_admin.joins(:editors).where(editors: { user_id: current_user.id }).order(starts_at: :desc)
    end
  end

  def show
    @poll = Poll.find(params[:id])
  end

  def new
  end

  def create
    @poll = Poll.new(poll_params.merge(author: current_user))

    if @poll.save
      notice = t("flash.actions.create.poll")
      if @poll.budget.present?
        redirect_to edition_poll_booth_assignments_path(@poll), notice: notice
      else
        redirect_to [:edition, @poll], notice: notice
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @poll.update(poll_params)
      redirect_to [:edition, @poll], notice: t("flash.actions.update.poll")
    else
      render :edit
    end
  end

  def add_question
    question = ::Poll::Question.find(params[:question_id])

    if question.present?
      @poll.questions << question
      notice = t("admin.polls.flash.question_added")
    else
      notice = t("admin.polls.flash.error_on_question_added")
    end
    redirect_to edition_poll_path(@poll), notice: notice
  end

  def booth_assignments
    @polls = Poll.not_expired_or_recounting.created_by_admin
    @polls_booth = []
    @polls.each do |poll|
      next if poll.budget_poll? && !poll.budget.balloting_enabled?
      @polls_booth << poll
    end
  end

  def destroy
    if ::Poll::Voter.where(poll: @poll).any?
      redirect_to edition_poll_path(@poll), alert: t("admin.polls.destroy.unable_notice")
    else
      @poll.destroy!

      redirect_to edition_polls_path, notice: t("admin.polls.destroy.success_notice")
    end
  end

  private

    def block_edition
      raise CanCan::AccessDenied unless @poll.editable? && @poll.editors.includes(current_user) || current_user.administrator?
    end

    def load_geozones
      @subs = Geozone.all.where(active: true, district: false).order(:name)
      @districts = Geozone.all.where(active: true, district: true).order(:name)
    end

    def poll_params
      if current_user.administrator?
        attributes = [:name, :starts_at, :ends_at, :geozone_restricted, :budget_id,
                      :electoral_college_restricted,
                      geozone_ids: [], image_attributes: image_attributes]
      elsif current_user.editor?
        attributes = [:name, image_attributes: image_attributes]
      end

      params.require(:poll).permit(*attributes, *report_attributes, translation_params(Poll))
    end

    def search_params
      params.permit(:poll_id, :search)
    end

    def load_search
      @search = search_params[:search]
    end

    def resource
      @poll ||= Poll.find(params[:id])
    end

    def is_admin?
      current_user.administrator?
    end
end
