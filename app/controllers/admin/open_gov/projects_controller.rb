class Admin::OpenGov::ProjectsController < Admin::BaseController
  include ImageAttributes

  load_and_authorize_resource class: "OpenGov::Project"

  before_action :load_project, only: [:show, :edit, :update, :destroy]

  def new
    @project = OpenGov::Project.new
  end

  def create
    @project = OpenGov::Project.new(project_params)

    if @project.save
      redirect_to admin_open_gov_articles_path,
        notice: t("admin.open_gov.projects.create.notice")
    else
      render :new
    end
  end

  def update
    if @project.update(project_params)
      redirect_to admin_open_gov_articles_path,
        notice: t("admin.open_gov.projects.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to admin_open_gov_articles_path,
      notice: t("admin.open_gov.projects.delete.notice")
  end

  private

  def project_params
    params.require(:open_gov_project).permit(
      :title, :link_url, image_attributes: image_attributes
    )
  end

  def load_project
    @project = OpenGov::Project.find(params[:id])
  end

end
