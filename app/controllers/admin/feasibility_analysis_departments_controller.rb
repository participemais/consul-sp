class Admin::FeasibilityAnalysisDepartmentsController < Admin::BaseController
  before_action :load_department, only: [:edit, :update, :destroy]

  def index
    @departments = FeasibilityAnalysis::Department.all
  end

  def new
    @department = FeasibilityAnalysis::Department.new
  end

  def create
    @department = FeasibilityAnalysis::Department.new(department_params)

    if @department.save
      redirect_to admin_feasibility_analysis_departments_path,
                  notice: t("admin.departments.create.notice")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @department.update(department_params)
      redirect_to admin_feasibility_analysis_departments_path,
                  notice: t("admin.departments.update.notice")
    else
      render :edit
    end
  end

  def destroy
    @department.destroy!
    redirect_to admin_feasibility_analysis_departments_path,
                notice: t("admin.departments.delete.notice")
  end

  private

    def load_department
      @department = FeasibilityAnalysis::Department.find(params[:id])
    end

    def department_params
      params.require(:feasibility_analysis_department).permit([:name])
    end
end
