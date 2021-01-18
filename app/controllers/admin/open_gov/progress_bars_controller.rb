class Admin::OpenGov::ProgressBarsController < Admin::ProgressBarsController
  def index
    @plan = progressable
  end

  private

    def progressable
      ::OpenGov::Plan.find(params[:plan_id])
    end
end
