class Legislation::TopicVotesController < Legislation::BaseController
  before_action :authenticate_user!

  load_and_authorize_resource :process
  load_and_authorize_resource :topic_vote

  respond_to :js

  def create
    if @process.topics_phase.open?
      @topic_vote.user = current_user
      @topic_vote.save!
      track_event
    end
  end

  def update
    if @process.topics_phase.open?
      @topic_vote.update(topic_vote_params)
    end
  end

  private

    def topic_vote_params
      params.require(:legislation_topic_vote).permit(
        :legislation_assessment_id, :legislation_topic_id, :comment
      )
    end

    def track_event
      ahoy.track "legislation_topic_vote_created".to_sym,
                 "legislation_topic_vote_id": @topic_vote.id,
                 "legislation_assessment_id": @topic_vote.legislation_assessment_id,
                 "legislation_topic_id": @topic_vote.legislation_topic_id
    end
end
