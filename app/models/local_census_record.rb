class LocalCensusRecord < ApplicationRecord
  include DocumentValidation

  before_validation :sanitize
  before_save :sanitize_attributes

  validates :document_number, presence: true
  validates :document_type, presence: true
  validates :document_type, inclusion: { in: User.document_type_options }
  validates :date_of_birth, presence: true
  validates :postal_code, presence: true
  validates :document_number, uniqueness: true
  validates :gender, inclusion: {
    in: ->(record) { record.class.gender_options }, allow_blank: true
  }
  validates :ethnicity, inclusion: {
    in: ->(record) { record.class.ethnicity_options }, allow_blank: true
  }

  scope :search, ->(terms) { where("document_number ILIKE ?", "%#{terms}%") }

  def self.gender_options
    gender_values.keys.map(&:downcase)
  end

  def self.ethnicity_options
    ethnicity_values.keys.map(&:downcase)
  end

  private

    def sanitize_attributes
      self.document_type = self.document_type.downcase
      set_gender if gender.present?
      set_ethnicity if ethnicity.present?
    end

    def sanitize
      self.document_type = self.document_type&.upcase&.strip
      self.document_number = self.document_number&.strip
      self.postal_code = self.postal_code&.strip
      self.gender = self.gender&.downcase&.strip
      self.ethnicity = self.ethnicity&.downcase&.strip
    end

    def self.gender_values
      local_census_record_translation_attr(:gender_options).invert
    end

    def self.ethnicity_values
      local_census_record_translation_attr(:ethnicity_options).invert
    end

    def self.local_census_record_translation_attr(attr_key)
      I18n.t(attr_key, scope: 'activerecord.attributes.local_census_record')
    end

    def set_gender
      self.gender = self.class.gender_values[gender.capitalize]
    end

    def set_ethnicity
      self.ethnicity = self.class.ethnicity_values[ethnicity.capitalize]
    end
end
