class Admin::BudgetGroupImportsController < Admin::BaseController
  load_and_authorize_resource class: "Budget::Group::Import"
  load_and_authorize_resource :budget
  load_and_authorize_resource :group, class: "Budget::Group"

  def create
    @import = Budget::Group::Import.new(budget_group_import_params, params[:group_id])
    if @import.save
      flash.now[:notice] = t("Grupo importado com sucesso.")
      redirect_to admin_budget_group_headings_path(@budget, @group)
    else
      render :new
    end
  end
  
  def new
    @import = Budget::Group::Import.new
  end

  private

    def budget_group_import_params
      return {} unless params[:budget_group_import].present?

      params.require(:budget_group_import).permit(:file)
    end
end
