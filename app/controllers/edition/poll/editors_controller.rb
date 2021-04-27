class Edition::Poll::EditorsController < Edition::Poll::BaseController

  load_and_authorize_resource :poll

  def index
    @editors = Editor.includes(:user).order("users.email ASC").page(params[:page])
  end

  def create
    if EditorPoll.create(editor_poll_params)
      link = poll_path(@poll)
      redirect_back(fallback_location: (request.referer || root_path),
                    notice: t("flash.actions.update.poll", link: link))
    else
      flash.now[:error] = t("flash.actions.update.poll_error")
      render :index
    end
  end

  def destroy
    EditorPoll.find_by(poll_id: params[:poll_id], editor_id: params[:id]).destroy
    link = poll_path(@poll)
    redirect_back(fallback_location: (request.referer || root_path),
                    notice: t("flash.actions.update.poll", link: link))
  end

  def search
    @editors = Editor.search(params[:name_or_email]).page(params[:page])
    render :index
  end

  private

    def editor_poll_params
      params.require(:editor_poll).permit(:poll_id, :editor_id)
    end

    def resource
      @poll || Poll.find(params[:id])
    end

end
