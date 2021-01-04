class Admin::Poll::RecountsController < Admin::Poll::BaseController
  before_action :load_poll

  def index
    @stats = Poll::Stats.new(@poll)

    @booth_assignments = @poll.booth_assignments
      .includes(:booth, :recounts, :voters)
      .order("poll_booths.name")
      .page(params[:page]).per(50)

    @partial_results = @poll.partial_results
  end

  private

    def load_poll
      @poll = ::Poll.find(params[:poll_id])
    end
end
