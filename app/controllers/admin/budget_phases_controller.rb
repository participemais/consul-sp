class Admin::BudgetPhasesController < Admin::BaseController
  include Translatable

  before_action :load_phase, only: [:edit, :update]
  after_action :update_poll, only: [:update], if: :balloting?

  def edit
  end

  def update
    if @phase.update(budget_phase_params)
      notice = t("flash.actions.save_changes.notice")
      redirect_to edit_admin_budget_path(@phase.budget), notice: notice
    else
      render :edit
    end
  end

  private

    def load_phase
      @phase = Budget::Phase.find(params[:id])
    end

    def budget_phase_params
      valid_attributes = [:starts_at, :ends_at, :enabled]
      params.require(:budget_phase).permit(*valid_attributes, translation_params(Budget::Phase))
    end

    def update_poll
      if @phase.starts_at != @phase.budget.poll.starts_at || @phase.ends_at != @phase.budget.poll.ends_at
        @phase.budget.poll.update(starts_at: @phase.starts_at, ends_at: @phase.ends_at)
      end
    end

    def balloting?
      @phase.kind == "balloting"
    end
end
