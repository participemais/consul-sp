class Legislation::TopicsController < Legislation::BaseController
  skip_before_action :verify_authenticity_token

  load_and_authorize_resource :process
  load_and_authorize_resource

  def comments
    @topics = @process.root_topics
  end
end
