class Edition::Poll::ResultsController < Edition::Poll::BaseController
  before_action :load_poll
  authorize_resource :poll

  private

    def load_poll
      @poll = ::Poll.includes(:questions).find(params[:poll_id])
    end
end
