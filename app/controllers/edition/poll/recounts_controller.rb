class Edition::Poll::RecountsController < Edition::Poll::BaseController
  before_action :load_poll
  before_action :authorize_editor


  def index
    @stats = Poll::Stats.new(@poll)

    @booth_assignments = @poll.booth_assignments
      .includes(:booth, :recounts, :voters)
      .order("poll_booths.name")
      .page(params[:page]).per(50)

    @partial_results = @poll.partial_results
  end

  private

    def authorize_editor
      if current_user.editor?
        if current_user.editor.poll_ids.include?(params[:poll_id].to_i)
          return
        else
          raise CanCan::AccessDenied.new
        end
      end
    end

    def load_poll
      @poll = ::Poll.find(params[:poll_id])
    end
end
