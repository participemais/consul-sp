class Officing::Residence
  include ActiveModel::Model
  include ActiveModel::Dates
  include ActiveModel::Validations::Callbacks

  attr_accessor :user, :officer, :document_number, :document_type, :date_of_birth, :postal_code

  before_validation :retrieve_census_data

  validates :document_number, presence: true
  validates :document_type, presence: true
  validates :date_of_birth, presence: true, if: -> { Setting.force_presence_date_of_birth? }
  validates :postal_code, presence: true, if: -> { Setting.force_presence_postal_code? }

  def initialize(attrs = {})
    self.date_of_birth = parse_date("date_of_birth", attrs)
    attrs = remove_date("date_of_birth", attrs)
    super
    clean_document_number
  end

  def save
    return false unless valid?

    if user_exists?
      self.user = find_user_by_document
      user.update!(verified_at: Time.current)
    else
      user_params = {
        document_number:       document_number,
        document_type:         document_type,
        geozone:               geozone,
        date_of_birth:         response_date_of_birth&.in_time_zone&.to_datetime,
        gender:                gender,
        ethnicity:             ethnicity,
        residence_verified_at: Time.current,
        verified_at:           Time.current,
        erased_at:             Time.current,
        password:              random_password,
        email:                 nil
      }
      self.user = User.create!(user_params)
    end
  end

  def save!
    validate! && save
  end

  def store_failed_census_call
    FailedCensusCall.create(
      user: user,
      document_number: document_number,
      document_type: document_type,
      date_of_birth: date_of_birth,
      postal_code: postal_code,
      poll_officer: officer
    )
  end

  def user_exists?
    find_user_by_document.present?
  end

  def find_user_by_document
    User.find_by(document_number: document_number, document_type: document_type)
  end

  def residence_in_madrid
    return if errors.any?

    unless residency_valid?
      store_failed_census_call
      errors.add(:residence_in_madrid, false)
    end
  end

  def geozone
    Geozone.find_by(census_code: district_code)
  end

  def district_code
    @census_api_response.district_code
  end

  def gender
    gender = @census_api_response.gender
    gender if gender.present?
  end

  def ethnicity
    ethnicity = @census_api_response.ethnicity
    ethnicity if ethnicity.present?
  end

  def response_date_of_birth
    @census_api_response.date_of_birth
  end

  private

    def retrieve_census_data
      @census_api_response = CensusCaller.new.call(document_type,
                                                   document_number,
                                                   date_of_birth,
                                                   postal_code)
    end

    def residency_valid?
      @census_api_response.valid?
    end

    def clean_document_number
      self.document_number = document_number.gsub(/[^a-z0-9]+/i, "").upcase if document_number.present?
    end

    def random_password
      (0...20).map { ("a".."z").to_a[rand(26)] }.join
    end
end
