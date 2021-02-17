class Admin::OpenGov::MarksController < Admin::BaseController

  load_and_authorize_resource class: "OpenGov::Mark"
  load_and_authorize_resource :commitment, class: "OpenGov::Commitment"
  load_and_authorize_resource :plan, class: "OpenGov::Plan"

  before_action :load_mark, only: [:edit, :update, :destroy]


  def new
  end

  def create
    @mark = OpenGov::Mark.new(mark_params)

    if @mark.save
      redirect_to admin_open_gov_plan_commitment_path(@plan, @commitment),
        notice: t("admin.open_gov.marks.create.notice")
    else
      render :new
    end
  end

  def update
    if @mark.update(mark_params)
      redirect_to admin_open_gov_plan_commitment_path(@plan, @commitment),
        notice: t("admin.open_gov.marks.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @mark.destroy
    redirect_to admin_open_gov_plan_commitment_path(@plan, @commitment),
      notice: t("admin.open_gov.marks.delete.notice")
  end

  private

  def mark_params
    params.require(:open_gov_mark).permit(:title, 
      :starts_at,
      :ends_at,
      :author,
      :status,
      :delivered,
      :open_gov_commitment_id,
      documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id])
  end

  def load_mark
    @mark = OpenGov::Mark.find(params[:id])
  end

end
