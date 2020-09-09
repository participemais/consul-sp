class Legislation::Topic < ApplicationRecord
  has_ancestry
  belongs_to :process,
    foreign_key: "legislation_process_id",
    inverse_of: :topics

  belongs_to :legislation_topic_level

  validates :title, presence: true
end
