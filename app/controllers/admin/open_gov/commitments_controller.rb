class Admin::OpenGov::CommitmentsController < Admin::BaseController

  load_and_authorize_resource class: "OpenGov::Commitment"
  load_and_authorize_resource :plan, class: "OpenGov::Plan"

  before_action :load_commitment, only: [:show, :edit, :update, :destroy]


  def new
  end

  def create
    @commitment = OpenGov::Commitment.new(commitment_params)

    if @commitment.save
      redirect_to admin_open_gov_plan_path(@plan),
        notice: t("admin.open_gov.commitments.create.notice")
    else
      render :new
    end
  end

  def update
    if @commitment.update(commitment_params)
      redirect_to admin_open_gov_plan_path(@plan),
        notice: t("admin.open_gov.commitments.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @commitment.destroy
    redirect_to admin_open_gov_plan_path(@plan),
      notice: t("admin.open_gov.commitments.delete.notice")
  end

  private

  def commitment_params
    params.require(:open_gov_commitment).permit(:title, 
      :starts_at,
      :ends_at,
      :coordenation,
      :work_group,
      :open_gov_plan_id)
  end

  def load_commitment
    @commitment = OpenGov::Commitment.find(params[:id])
  end

end
