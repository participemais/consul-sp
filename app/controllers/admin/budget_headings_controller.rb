class Admin::BudgetHeadingsController < Admin::BaseController
  include Translatable
  include FeatureFlags
  feature_flag :budgets

  before_action :load_budget
  before_action :load_group
  before_action :load_heading, except: [:index, :new, :create]

  def index
    @headings = @group.headings.order(:id)
  end

  def edit
  end

  def update
    if @heading.update(budget_heading_params)
      redirect_to headings_index, notice: t("admin.budget_headings.update.notice")
    else
      render :edit
    end
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:budget_id]
    end

    def load_group
      @group = @budget.groups.find_by_slug_or_id! params[:group_id]
    end

    def load_heading
      @heading = @group.headings.find_by_slug_or_id! params[:id]
    end

    def headings_index
      admin_budget_group_headings_path(@budget, @group)
    end

    def budget_heading_params
      valid_attributes = [:area, :population, :latitude, :longitude, :description, districts_attributes: [:id, :name, :description, :area, :population, :_destroy] ]
 
      params.require(:budget_heading).permit(*valid_attributes, translation_params(Budget::Heading))
    end
end
