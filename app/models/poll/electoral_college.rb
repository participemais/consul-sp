class Poll
  class ElectoralCollege < ApplicationRecord
    belongs_to :poll
    has_many :electors,
      class_name: "Poll::Elector",
      foreign_key: "poll_electoral_college_id",
      dependent: :destroy

    after_save :schedule_electoral_college_deactivation

    def filename
      title.parameterize
    end

    def deactivate_electoral_college
      self.update(active: false)
    end

    private

    def schedule_electoral_college_deactivation
      self.delay(
        priority: 10, run_at: poll.ends_at.end_of_day, queue: "schedules"
      ).deactivate_electoral_college
    end
  end
end
