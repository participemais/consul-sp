class Admin::Legislation::EditorsController < Admin::Legislation::BaseController

  load_and_authorize_resource :process, class: "Legislation::Process"

  def index
    @editors = Editor.includes(:user).order("users.email ASC").page(params[:page])
  end

  def update
    if @process.update(process_params)
      link = legislation_process_path(@process)
      redirect_back(fallback_location: (request.referer || root_path),
                    notice: t("admin.legislation.processes.update.notice", link: link))
    else
      flash.now[:error] = t("admin.legislation.processes.update.error")
      render :edit
    end
  end

  def search
    @users = User.search(params[:name_or_email])
                 .includes(:editor)
                 .page(params[:page])
                 .for_render
  end

  private

    def process_params
      params.require(:legislation_process).permit([ editor_ids: [] ])
    end

    def resource
      @process || ::Legislation::Process.find(params[:id])
    end

end
