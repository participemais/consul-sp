class OpenGov::ArticlesController < ApplicationController

  load_and_authorize_resource class: "OpenGov::Article"

  valid_filters = %w[government participation action_plan]
  has_filters valid_filters, only: [:index, :show]

  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def index
    @current_filter = params[:filter]

    @articles = OpenGov::Article.all.order(created_at: :desc)
    @participation_article = OpenGov::ParticipationArticle.first
    @projects = OpenGov::Project.all

    if params[:action_plan_id].present?
      @current_action_plan = OpenGov::Plan.find(params[:action_plan_id])
    else
      @current_action_plan = OpenGov::Plan.current
    end

    @action_plans = OpenGov::Plan.select { |plan| plan.id != @current_action_plan.id }.sort_by(&:starts_at).reverse!
  end

  def show
  end

  private

  def load_article
    @article = OpenGov::Article.find(params[:id])
  end
end
