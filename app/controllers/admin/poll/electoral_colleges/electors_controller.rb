class Admin::Poll::ElectoralColleges::ElectorsController < Admin::Poll::BaseController
  before_action :load_elector, only: [:edit, :update, :destroy]

  load_and_authorize_resource :electoral_college,
    class: "::Poll::ElectoralCollege"
  load_and_authorize_resource :poll
  load_and_authorize_resource class: "Poll::Elector"

  def new
    @elector = Poll::Elector.new
  end

  def create
    @elector = Poll::Elector.new(elector_params)

    if @elector.save
      redirect_to admin_poll_electoral_colleges_path(@poll),
        notice: t("flash.actions.create.poll_electoral_college_elector")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @elector.update(elector_params)
      redirect_to admin_poll_electoral_colleges_path(@poll),
        notice: t("flash.actions.update.poll_electoral_college_elector")
    else
      render :edit
    end
  end

  def destroy
    @elector.destroy
    redirect_to admin_poll_electoral_colleges_path(@poll),
      notice: t("flash.actions.destroy.poll_electoral_college_elector")
  end


  private

  def elector_params
    params.require(:poll_elector).permit(
      :document_type, :document_number, :category, :poll_electoral_college_id
    )
  end

  def load_elector
    @elector = Poll::Elector.find(params[:id])
  end
end
