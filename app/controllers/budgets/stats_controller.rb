module Budgets
  class StatsController < ApplicationController
    before_action :load_budget
    load_and_authorize_resource :budget

    def show
      authorize! :read_stats, @budget
      @stats = Budget::Stats.new(@budget)
      @headings = @budget.headings.sort_by_name
      respond_to do |format|
        format.html
        format.csv do
          send_data Budget::Participants::Exporter.new(@stats.participants).to_csv,
            filename: "participacao-#{@budget.filename}.csv"
        end
      end
    end

    private

      def load_budget
        @budget = Budget.find_by_slug_or_id! params[:budget_id]
      end
  end
end
