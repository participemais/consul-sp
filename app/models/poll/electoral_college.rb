class Poll
  class ElectoralCollege < ApplicationRecord
    has_many :polls, foreign_key: "poll_electoral_college_id"
    has_many :electors,
      class_name: "Poll::Elector",
      foreign_key: "poll_electoral_college_id",
      dependent: :destroy
  end
end
