class Poll
  class Elector < ApplicationRecord
    belongs_to :electoral_college,
      class_name: "Poll::ElectoralCollege",
      foreign_key: "poll_electoral_college_id"

    belongs_to :user
  end
end
