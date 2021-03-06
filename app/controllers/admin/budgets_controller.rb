class Admin::BudgetsController < Admin::BaseController
  include Translatable
  include ReportAttributes
  include FeatureFlags
  feature_flag :budgets

  has_filters %w[open finished], only: :index

  before_action :load_budget, except: [:index, :new, :create]
  before_action :load_categories, except: [:destroy]
  before_action :load_selected_categories, only: [:edit, :update, :show]
  before_action :update_poll, only: [:update]
  load_and_authorize_resource

  def index
    @budgets = Budget.send(@current_filter).order(created_at: :desc).page(params[:page])
  end

  def show
  end

  def new
    load_staff
  end

  def edit
    load_staff
  end

  def calculate_winners
    return unless @budget.balloting_process?

    @budget.headings.each { |heading| Budget::Result.new(@budget, heading).delay.calculate_winners }
    redirect_to admin_budget_budget_investments_path(
                  budget_id: @budget.id,
                  advanced_filters: ["winners"]),
                notice: I18n.t("admin.budgets.winners.calculated")
  end

  def update
    if @budget.update(budget_params)

      send_selected_and_unselected_emails if @budget.balloting?

      redirect_to admin_budgets_path, notice: t("admin.budgets.update.notice")
    else
      load_staff
      render :edit
    end
  end

  def create
    @budget = Budget.new(budget_params)
    if @budget.save
      redirect_to admin_budget_path(@budget), notice: t("admin.budgets.create.notice")
    else
      load_staff
      render :new
    end
  end

  def destroy
    if @budget.investments.any?
      redirect_to admin_budgets_path, alert: t("admin.budgets.destroy.unable_notice")
    elsif @budget.poll.present?
      redirect_to admin_budgets_path, alert: t("admin.budgets.destroy.unable_notice_polls")
    else
      @budget.destroy!
      redirect_to admin_budgets_path, notice: t("admin.budgets.destroy.success_notice")
    end
  end

  private

    def budget_params
      descriptions = Budget::Phase::PHASE_KINDS.map { |p| "description_#{p}" }.map(&:to_sym)
      valid_attributes = [:phase,
                          :custom_list,
                          :currency_symbol,
                          :max_votes,
                          administrator_ids: [],
                          valuator_ids: []
      ] + descriptions
      params.require(:budget).permit(*valid_attributes, *report_attributes, translation_params(Budget))
    end

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end

    def load_staff
      @admins = Administrator.includes(:user)
      @valuators = Valuator.includes(:user).order(description: :asc).order("users.email ASC")
    end

    def send_selected_and_unselected_emails
      @budget.email_selected
      @budget.email_unselected
    end

    def load_categories
      @categories = Tag.where(kind: "category").order(:name)
    end

    def load_selected_categories
      @all_tags = @budget.custom_list
    end

    def update_poll
      if @budget.poll.present?
        older_name = @budget.name
        new_name = budget_params["translations_attributes"]["2"]["name"]

        @budget.poll.update(name: new_name) if older_name != new_name

        balloting = @budget.phases.find_by_kind("balloting")

        if balloting.starts_at != @budget.poll.starts_at || balloting.ends_at != @budget.poll.ends_at
          @budget.poll.update(starts_at: balloting.starts_at, ends_at: balloting.ends_at)
        end
      end
    end
end
