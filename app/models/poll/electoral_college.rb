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

    def destroy_existing_jobs
      Delayed::Job.where(queue: queue_name).each do |job|
        job.destroy if job.payload_object.id == self.id
      end
    end

    def queue_name
      "schedules"
    end

    private

    def schedule_electoral_college_deactivation
      destroy_existing_jobs
      self.delay(
        priority: 10, run_at: poll.ends_at.end_of_day, queue: queue_name
      ).deactivate_electoral_college
    end
  end
end
