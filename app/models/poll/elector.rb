class Poll
  class Elector < ApplicationRecord
    before_validation :sanitize

    belongs_to :electoral_college,
      class_name: "Poll::ElectoralCollege",
      foreign_key: "poll_electoral_college_id"

    belongs_to :user

    validates :document_type, presence: true
    validates :document_type,
      inclusion: { in: User::DOCUMENT_TYPES, allow_blank: true }

    validates :document_number, presence: true
    validates :document_number, uniqueness: { scope: :electoral_college }

    validate :cpf_number, if: :local_document?

    scope :user_not_found, -> { where(user_found: false) }
    scope :active_electoral_college, -> do
      joins(:electoral_college).where(electoral_college: { active: true })
    end
    scope :by_document, ->(document_type, document_number) do
      where(document_type: document_type, document_number: document_number)
    end

    private

    def local_document?
      document_number.present? && document_type == 'cpf'
    end

    def cpf_number
      unless CPF.valid?(document_number)
        message = I18n.t(
          :invalid_number,
          scope: 'activerecord.errors.models.user.attributes.cpf'
        )
        errors.add(:document_number, message)
      end
    end

    def sanitize
      self.document_type = document_type&.downcase&.strip
      self.document_number = document_number&.upcase&.strip
      self.category = category&.strip
    end
  end
end
