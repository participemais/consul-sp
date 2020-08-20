class Admin::FeasibilityAnalysesController < Admin::BaseController

  before_action :load_feasibility_analyzable
  before_action :load_feasibility_analysis, only: [:edit, :update, :destroy]
  helper_method :feasibility_analyzable_path

  def new
    @feasibility_analysis = @feasibility_analyzable.feasibility_analyses.new
  end

  def create
    @feasibility_analysis = @feasibility_analyzable
      .feasibility_analyses.new(feasibility_analysis_params)
    if @feasibility_analysis.save
      redirect_to feasibility_analyzable_path,
        notice: t("admin.feasibility_analyses.create.notice")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @feasibility_analysis.update(feasibility_analysis_params)
      redirect_to feasibility_analyzable_path,
        notice: t("admin.feasibility_analyses.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @feasibility_analysis.destroy!
    redirect_to feasibility_analyzable_path,
      notice: t("admin.feasibility_analyses.delete.notice")
  end

  private

  def feasibility_analysis_params
    params.require(:feasibility_analysis).permit(
      :feasibility_analyses, :technical, :technical_description, :legal,
      :legal_description, :budgetary, :budgetary_description,
      :budgetary_actions, :sei_number, :responsible
    )
  end

  def load_feasibility_analyzable
    @feasibility_analyzable = feasibility_analyzable
  end

  def load_feasibility_analysis
    @feasibility_analysis =
      @feasibility_analyzable.feasibility_analyses.find(params[:id])
  end

  def feasibility_analyzable_path
    edit_polymorphic_url([
      :valuation,
      *resource_hierarchy_for(@feasibility_analysis.feasibility_analyzable)
    ])
  end

end
