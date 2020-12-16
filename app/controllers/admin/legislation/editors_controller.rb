class Admin::Legislation::EditorsController < Admin::Legislation::BaseController

  load_and_authorize_resource :process, class: "Legislation::Process"

  def index
    @editors = Editor.includes(:user).order("users.email ASC").page(params[:page])
  end

  def create
    if EditorLegislationProcess.create(editor_legislation_process_params)
      link = legislation_process_path(@process)
      redirect_back(fallback_location: (request.referer || root_path),
                    notice: t("admin.legislation.processes.update.notice", link: link))
    else
      flash.now[:error] = t("admin.legislation.processes.update.error")
      render :index
    end
  end

  def destroy
    EditorLegislationProcess.find_by(legislation_process_id: params[:process_id], editor_id: params[:id]).destroy
    link = legislation_process_path(@process)
    redirect_back(fallback_location: (request.referer || root_path),
                    notice: t("admin.legislation.processes.update.notice", link: link))
  end

  def search
    @users = User.search(params[:name_or_email])
                 .includes(:editor)
                 .page(params[:page])
                 .for_render
  end

  private

    def editor_legislation_process_params
      params.require(:editor_legislation_process).permit(:legislation_process_id, :editor_id)
    end

    def resource
      @process || ::Legislation::Process.find(params[:id])
    end

end
