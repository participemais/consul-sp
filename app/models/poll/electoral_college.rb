class Poll
  class ElectoralCollege < ApplicationRecord
    has_many :polls, foreign_key: "poll_electoral_college_id"
  end
end
