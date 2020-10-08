module LegislationTopicsHelper
  def topic_level_label(indexes)
    "#{indexes.*('.')}."
  end

  def topic_indexes(indexes, index, counter_level)
    if index == 1
      indexes << index
    else
      indexes = indexes.first(counter_level)
      indexes[-1] = index
    end
    indexes
  end

  def delete_topic_confirmation(topic)
    if topic.children.any?
      { confirm: destroy_topic_message(topic) }
    end
  end

  def find_or_build_topic_vote(topic)
    user_topic_vote(topic) || Legislation::TopicVote.new
  end

  def user_topic_vote(topic)
    topic.topic_vote_for_user(current_user)
  end

  def topic_vote_url(topic, topic_vote)
    if topic_vote.new_record?
      legislation_process_topic_topic_votes_path(@process, topic)
    else
      legislation_process_topic_topic_vote_path(@process, topic, topic_vote)
    end
  end

  def hide_box
    if ['create', 'update'].include?(params[:action])
      ""
    else
      "hide-fields"
    end
  end

  def topic_vote_submit(topic_vote)
    topic_vote.new_record? ? "new" : "edit"
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
