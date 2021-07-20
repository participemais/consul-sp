class Poll
  class Voter < ApplicationRecord
    VALID_ORIGINS = %w[web booth letter].freeze

    belongs_to :poll
    belongs_to :user
    belongs_to :geozone
    belongs_to :booth_assignment
    belongs_to :officer_assignment
    belongs_to :officer

    validates :poll_id, presence: true
    validates :user_id, presence: true
    validates :booth_assignment_id, presence: true, if: ->(voter) { voter.origin == "booth" }
    validates :officer_assignment_id, presence: true, if: ->(voter) { voter.origin == "booth" }

    validates :document_number, presence: true, uniqueness: { scope: [:poll_id, :document_type], message: :has_voted }
    validates :origin, inclusion: { in: VALID_ORIGINS }

    before_validation :set_demographic_info, :set_document_info, :set_denormalized_booth_assignment_id

    scope :web,    -> { where(origin: "web") }
    scope :booth,  -> { where(origin: "booth") }
    scope :letter, -> { where(origin: "letter") }
    scope :male,           -> { where(gender: "male") }
    scope :female,         -> { where(gender: "female") }
    scope :non_binary,     -> { where(gender: "non_binary") }
    scope :unknown,        -> { where(gender: "unknown") }
    scope :by_ethnicity, ->(ethnicity) { where(ethnicity: ethnicity) }
    scope :resident,     -> { where(uf: 'SP') }
    scope :non_resident, -> { where.not(uf: 'SP') }
    scope :from_sp,  -> { where(city: 'São Paulo', uf: 'SP') }
    scope :not_from_sp,  -> { where.not(city: 'São Paulo') }

    def set_demographic_info
      return if user.blank?

      self.gender = user.gender
      self.age = user.age
      self.geozone = user.geozone
      self.ethnicity = user.ethnicity
      self.uf = user.uf
      self.city = user.city
      self.date_of_birth = user.date_of_birth
    end

    def set_document_info
      return if user.blank?

      self.document_type   = user.document_type
      self.document_number = user.document_number
    end

    private

      def set_denormalized_booth_assignment_id
        self.booth_assignment_id ||= officer_assignment&.booth_assignment_id
      end
  end
end
