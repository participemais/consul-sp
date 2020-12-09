class Admin::Poll::ResultsController < Admin::Poll::BaseController
  before_action :load_poll

  private

    def load_poll
      @poll = ::Poll.includes(:questions).find(params[:poll_id])
    end
end
