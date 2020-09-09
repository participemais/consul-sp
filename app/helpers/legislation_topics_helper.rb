module LegislationTopicsHelper
  def topic_level_label(indexes)
    "#{indexes.*('.')}."
  end

  def delete_topic_confirmation(topic)
    if topic.children.any?
      { confirm: destroy_topic_message(topic) }
    end
  end

  private

  def destroy_topic_message(topic)
    t(
      'admin.legislation.topics.destroy.confirm',
      title: topic.title,
      count: topic.descendants.size
    )
  end
end
