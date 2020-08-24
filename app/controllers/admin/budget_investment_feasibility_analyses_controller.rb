class Admin::BudgetInvestmentFeasibilityAnalysesController < Admin::FeasibilityAnalysesController

  before_action :load_budget
  before_action :load_investment

  private

  def load_budget
    @budget = Budget.find_by_slug_or_id! params[:budget_id]
  end

  def load_investment
    @investment = feasibility_analyzable
  end

  def feasibility_analyzable
    Budget::Investment.find(params[:budget_investment_id])
  end

end
