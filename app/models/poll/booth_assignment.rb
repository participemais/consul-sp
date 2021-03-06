class Poll
  class BoothAssignment < ApplicationRecord
    belongs_to :booth
    belongs_to :poll

    before_destroy :destroy_poll_shifts, only: :destroy

    has_many :officer_assignments, dependent: :destroy
    has_many :officers, through: :officer_assignments
    has_many :voters
    has_many :partial_results
    has_many :recounts

    # def booth_name
    delegate :name, to: :booth, prefix: true

    def shifts?
      shifts.empty? ? false : true
    end

    def unable_to_destroy?
      (partial_results.count + recounts.count).positive?
    end

    def total_booth_valid
      recounts.sum(:total_amount)
    end

    def total_booth_white
      recounts.sum(:white_amount)
    end

    def total_booth_null
      recounts.sum(:null_amount)
    end

    def total_participants_booth
      total_booth_valid + total_booth_white + total_booth_null
    end

    def total_registered_booth
      voters.where(origin: "booth").count
    end

    private

      def shifts
        Poll::Shift.where(booth_id: booth_id, officer_id: officer_assignments.pluck(:officer_id), date: officer_assignments.pluck(:date))
      end

      def destroy_poll_shifts
        shifts.destroy_all
      end
  end
end
