class Admin::OpenGov::ParticipationArticlesController < Admin::BaseController

  load_and_authorize_resource class: "OpenGov::ParticipationArticle"

  before_action :load_article, only: [:show, :edit, :update, :destroy]

  def index
    @article = OpenGov::ParticipationArticle.first
  end

  def new
    @article = OpenGov::ParticipationArticle.new
  end

  def create
    @article = OpenGov::ParticipationArticle.new(participation_article_params)
    @article.author_id = current_user.id


    if @article.save
      redirect_to admin_open_gov_participation_articles_path,
        notice: t("admin.open_gov.articles.create.notice")
    else
      render :index
    end
  end

  def update
    if @article.update(participation_article_params)
      redirect_to admin_open_gov_participation_articles_path,
        notice: t("admin.open_gov.articles.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_open_gov_participation_articles_path,
      notice: t("admin.open_gov.articles.delete.notice")
  end

  private

  def participation_article_params
    params.require(:open_gov_participation_article).permit(:title, :text)
  end

  def load_article
    @article = OpenGov::ParticipationArticle.find(params[:id])
  end

end
