class Legislation::TopicsController < Legislation::BaseController
  load_and_authorize_resource :process
  load_and_authorize_resource

  def comments
    @topics = @process.root_topics
  end
end
