class OpenGov::ArticlesController < ApplicationController

  load_and_authorize_resource class: "OpenGov::Article"

  valid_filters = %w[government participation action_plan]
  has_filters valid_filters, only: [:index, :show]

  before_action :load_article, only: :show

  def index
    @articles = OpenGov::Article.all.order(created_at: :desc)
    @projects = OpenGov::Project.all
    @current_filter = params[:filter]
  end

  def show
  end

  private

  # def article_params
  #   params.require(:open_gov_article).permit(:title, :text)
  # end

  def load_article
    @article = OpenGov::Article.find(params[:id])
  end

end
