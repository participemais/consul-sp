class LocalCensusRecord < ApplicationRecord
  before_validation :sanitize
  before_save :sanitize_document_type

  validates :document_number, presence: true
  validates :document_type, presence: true
  validates :document_type, inclusion: { in: User.document_type_options }
  validates :date_of_birth, presence: true
  validates :postal_code, presence: true
  validates :document_number, uniqueness: true

  scope :search, ->(terms) { where("document_number ILIKE ?", "%#{terms}%") }

  private

    def sanitize_document_type
      self.document_type   = self.document_type.downcase
    end

    def sanitize
      self.document_type   = self.document_type&.upcase&.strip
      self.document_number = self.document_number&.strip
      self.postal_code     = self.postal_code&.strip
    end
end
