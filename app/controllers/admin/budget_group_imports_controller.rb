class Admin::BudgetGroupImportsController < Admin::BaseController
  load_and_authorize_resource class: "Budget::Group::Import"

  def create
    @import = Budget::Group::Import.new(budget_group_import_params)
    if @import.save
      flash.now[:notice] = t("Grupo importado com sucesso.")
      render :show
    else
      render :new
    end
  end
  
  def new
    
  end

  private

    def group_import_params
      return {} unless params[:budget_group_import].present?

      params.require(:budget_group_import).permit(:file)
    end
end
