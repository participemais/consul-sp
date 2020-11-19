class Editor < ApplicationRecord
	has_and_belongs_to_many :legislation_processes
  belongs_to :user, touch: true
  delegate :name, :email, :name_and_email, to: :user, allow_nil: true

  validates :user_id, presence: true, uniqueness: true
end