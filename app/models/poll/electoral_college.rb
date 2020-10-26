class Poll
  class ElectoralCollege < ApplicationRecord
    belongs_to :poll
    has_many :electors,
      class_name: "Poll::Elector",
      foreign_key: "poll_electoral_college_id",
      dependent: :destroy

    def filename
      title.parameterize
    end
  end
end
