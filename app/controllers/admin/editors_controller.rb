class Admin::EditorsController < Admin::BaseController
  load_and_authorize_resource

  def index
    @editors = @editors.page(params[:page])
  end

  def search
    @users = User.search(params[:name_or_email])
                 .includes(:editor)
                 .page(params[:page])
                 .for_render
  end

  def create
    @editor.user_id = params[:user_id]
    @editor.save!
    flash[:notice] = t("admin.editors.add")

    redirect_to admin_editors_path
  end

  def destroy
    if @editor.legislation_processes.any? || @editor.polls.any?
      flash[:error] = t("admin.editors.remove_error")
    else
      @editor.destroy!
      flash[:notice] = t("admin.editors.remove")
    end
    redirect_to admin_editors_path
  end
end
