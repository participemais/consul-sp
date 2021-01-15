class Admin::OpenGov::LinesController < Admin::BaseController

  load_and_authorize_resource class: "OpenGov::Line"
  load_and_authorize_resource :mark, class: "OpenGov::Mark"
  load_and_authorize_resource :commitment, class: "OpenGov::Commitment"
  load_and_authorize_resource :plan, class: "OpenGov::Plan"

  before_action :load_line, only: [:edit, :update, :destroy]


  def new
  end

  def create
    @line = OpenGov::Line.new(line_params)

    if @line.save
      redirect_to admin_open_gov_plan_commitment_path(@plan, @commitment),
        notice: t("admin.open_gov.lines.create.notice")
    else
      render :new
    end
  end

  def update
    if @line.update(line_params)
      redirect_to admin_open_gov_plan_commitment_path(@plan, @commitment),
        notice: t("admin.open_gov.lines.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @line.destroy
    redirect_to admin_open_gov_plan_commitment_path(@plan, @commitment),
      notice: t("admin.open_gov.lines.delete.notice")
  end

  private

  def line_params
    params.require(:open_gov_line).permit(:title, 
      :starts_at,
      :ends_at,
      :author,
      :status,
      :delivered,
      :open_gov_mark_id,
      documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id])
  end

  def load_line
    @line = OpenGov::Line.find(params[:id])
  end

end
