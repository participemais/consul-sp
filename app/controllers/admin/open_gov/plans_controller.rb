class Admin::OpenGov::PlansController < Admin::BaseController

  load_and_authorize_resource class: "OpenGov::Plan"

  before_action :load_plan, only: [:show, :edit, :update, :destroy]

  def index
    @plans = OpenGov::Plan.all
  end

  def new
    @plan = OpenGov::Plan.new
  end

  def create
    @plan = OpenGov::Plan.new(plan_params)

    if @plan.save
      redirect_to admin_open_gov_plan_path(@plan),
        notice: t("admin.open_gov.plans.create.notice")
    else
      render :new
    end
  end

  def update
    if @plan.update(plan_params)
      redirect_to admin_open_gov_plan_path(@plan),
        notice: t("admin.open_gov.plans.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to admin_open_gov_plans_path,
      notice: t("admin.open_gov.plans.delete.notice")
  end

  def participations

  end

  private

  def plan_params
    params.require(:open_gov_plan).permit(:title, :starts_at, :ends_at, :video_url, documents_attributes: [:id, :title, :attachment, :cached_attachment, :user_id])
  end

  def load_plan
    @plan = OpenGov::Plan.find(params[:id])
  end

end
