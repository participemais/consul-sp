class Edition::Poll::ElectoralColleges::ElectorsController < Edition::Poll::BaseController
  load_and_authorize_resource :electoral_college,
    class: "::Poll::ElectoralCollege"
  load_and_authorize_resource :poll
  load_and_authorize_resource class: "Poll::Elector"

  before_action :authorize_editor

  def search_electors
    load_search
    @electors = @electoral_college.electors.quick_search(@search)
    respond_to do |format|
      format.js
    end
  end

  def new
    @elector = Poll::Elector.new()
  end

  def create
    @elector = Poll::Elector.new(elector_params)

    if @elector.save
      redirect_to edition_poll_electoral_colleges_path(@poll),
        notice: t("admin.poll_electors.create.notice")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @elector.update(elector_params)
      redirect_to edition_poll_electoral_colleges_path(@poll),
        notice: t("admin.poll_electors.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @elector.destroy
    redirect_to edition_poll_electoral_colleges_path(@poll),
      notice: t("admin.poll_electors.destroy.notice")
  end


  private

  def authorize_editor
    if current_user.editor?
      if current_user.editor.poll_ids.include?(params[:poll_id].to_i)
        return
      else
        raise CanCan::AccessDenied.new
      end
    end
  end

  def elector_params
    params.require(:poll_elector).permit(
      :document_type, :document_number, :category, :poll_electoral_college_id
    )
  end

  def search_params
    params.permit(:poll_id, :electoral_college_id, :search)
  end

  def load_search
    @search = search_params[:search]
  end
end
