class Organization < ApplicationRecord
  include Graphqlable

  belongs_to :user, touch: true

  validates :name, presence: true
  validates :name, uniqueness: true
  validate  :validate_name_length
  validates :responsible_name, presence: true
  validates :responsible_name, length: { minimum: 2 }
  validate  :validate_responsible_name_length
  validate  :responsible_name_chars_validation
  validate  :responsible_full_name

  before_save :sanitaze_responsible_name

  delegate :email, :phone_number, to: :user

  scope :pending, -> { where(verified_at: nil, rejected_at: nil) }
  scope :verified, -> { where.not(verified_at: nil).where("(rejected_at IS NULL or rejected_at < organizations.verified_at)") }
  scope :rejected, -> { where.not(rejected_at: nil).where("(organizations.verified_at IS NULL or organizations.verified_at < rejected_at)") }

  def verify
    update(verified_at: Time.current)
  end

  def reject
    update(rejected_at: Time.current)
  end

  def verified?
    verified_at.present? &&
      (rejected_at.blank? || rejected_at < verified_at)
  end

  def rejected?
    rejected_at.present? &&
      (verified_at.blank? || verified_at < rejected_at)
  end

  def self.search(text)
    if text.present?
      joins(:user).where("users.email = ? OR users.phone_number = ? OR organizations.name ILIKE ?", text, text, "%#{text}%")
    else
      none
    end
  end

  def self.name_max_length
    @name_max_length ||= columns.find { |c| c.name == "name" }.limit || 60
  end

  def self.responsible_name_max_length
    @responsible_name_max_length ||= columns.find { |c| c.name == "responsible_name" }.limit || 60
  end

  private

    def validate_name_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :name,
        maximum: Organization.name_max_length)
      validator.validate(self)
    end

    def validate_responsible_name_length
      validator = ActiveModel::Validations::LengthValidator.new(
        attributes: :responsible_name,
        maximum: Organization.responsible_name_max_length)
      validator.validate(self)
    end

    def responsible_name_chars_validation
      unless responsible_name =~ /^[\sa-z\u00C0-\u017F\.\-]+$/i
        errors.add(:responsible_name)
      end
    end

    def responsible_full_name
      words = responsible_name.split
      if words.size < 2 || words.values_at(0, -1).any? { |word| word.size < 2 }
        message = I18n.t(
          :full_name_required,
          scope: 'activerecord.errors.models.organization.attributes.responsible_name'
        )
        errors.add(:responsible_name, message)
      end
    end

    def sanitaze_responsible_name
      if responsible_name_changed?
        self.responsible_name = responsible_name.squish.titleize
      end
    end
end
