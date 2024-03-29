class Editor < ApplicationRecord
	has_many :editor_legislation_processes, foreign_key: "editor_id"
	has_many :legislation_processes, through: :editor_legislation_processes, source: :process

	has_many :editor_polls, foreign_key: "editor_id"
	has_many :polls, through: :editor_polls

  belongs_to :user, touch: true
  delegate :name, :email, :name_and_email, to: :user, allow_nil: true

  validates :user_id, presence: true, uniqueness: true

  def self.search(term)
    term.present? ? joins(:user).where("users.email = ? OR users.username ILIKE ?", term, "%#{term}%") : none
  end

end