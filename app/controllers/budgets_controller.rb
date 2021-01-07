class BudgetsController < ApplicationController
  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  before_action :load_budget, only: :show
  before_action :load_ballot, only: :show
  before_action :load_categories, only: :show
  load_and_authorize_resource
  before_action :set_default_budget_filter, only: :show

  has_filters %w[unselected], only: :show

  respond_to :html, :js

  def show
    raise ActionController::RoutingError, "Not Found" unless budget_published?(@budget)
    @investments = investments.page(params[:page]).per(20).for_render
    @investment_ids = investments.pluck(:id)
    @tag_cloud = tag_cloud
  end

  def index
    @finished_budgets = @budgets.finished.order(created_at: :desc)
    @budgets_coordinates = current_budget_map_locations
    @banners = Banner.in_section("budgets").with_active
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end

    def investments
      @results ||= @budget.investments
        .apply_filters_and_search(@budget, params, @current_filter)
        .sort_by_heading
    end

    def tag_cloud
      TagCloud.new(Budget::Investment, params[:search])
    end

    def load_ballot
      query = Budget::Ballot.where(user: current_user, budget: @budget)
      @ballot = @budget.balloting? ? query.first_or_create! : query.first_or_initialize
    end

    def load_categories
      @categories = Tag.category.order(:name)
    end
end
