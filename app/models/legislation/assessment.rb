class Legislation::Assessment < ApplicationRecord
  belongs_to :legislation_topic

  validates :title, presence: true
end
