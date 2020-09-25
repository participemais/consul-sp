module Admin::FeasibilityAnalysisDepartmentsHelper
  def active_button(department)
    if department.active
      t("admin.departments.index.deactivate")
    else
      t("admin.departments.index.activate")
    end
  end
end
