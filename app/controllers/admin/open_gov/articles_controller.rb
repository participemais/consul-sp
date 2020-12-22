class Admin::OpenGov::ArticlesController < Admin::BaseController

  load_and_authorize_resource class: "OpenGov::Article"

  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = OpenGov::Article.all
    @projects = OpenGov::Project.all
  end

  def new
    @article = OpenGov::Article.new
  end

  def create
    @article = OpenGov::Article.new(article_params)
    @article.author_id = current_user.id

    if @article.save
      redirect_to admin_open_gov_article_path(@article),
        notice: t("admin.open_gov.articles.create.notice")
    else
      render :new
    end
  end

  def update
    if @article.update(article_params)
      redirect_to admin_open_gov_article_path(@article),
        notice: t("admin.open_gov.articles.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_open_gov_articles_path,
      notice: t("admin.open_gov.articles.delete.notice")
  end

  def participations

  end

  private

  def article_params
    params.require(:open_gov_article).permit(:title, :text)
  end

  def load_article
    @article = OpenGov::Article.find(params[:id])
  end

end
