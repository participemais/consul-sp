class Budget
  class Heading < ApplicationRecord
    OSM_DISTRICT_LEVEL_ZOOM = 12

    include Sluggable

    translates :name, touch: true
    include Globalizable
    translation_class_delegate :budget

    class Translation
      validate :name_uniqueness_by_budget

      def name_uniqueness_by_budget
        if budget.headings
                 .joins(:translations)
                 .where(name: name)
                 .where.not("budget_heading_translations.budget_heading_id": budget_heading_id).any?
          errors.add(:name, I18n.t("errors.messages.taken"))
        end
      end
    end

    belongs_to :group

    has_many :investments
    has_many :content_blocks
    has_many :districts, dependent: :destroy
    accepts_nested_attributes_for :districts, reject_if: :all_blank, allow_destroy: true


    validates_translation :name, presence: true
    validates :group_id, presence: true
    validates :price, presence: true, if: :budget_resource_allocation_balloting?
    validates :slug, presence: true, format: /\A[a-z0-9\-_]+\z/
    validates :latitude, length: { maximum: 22 }, allow_blank: true, \
              format: /\A(-|\+)?([1-8]?\d(?:\.\d{1,})?|90(?:\.0{1,6})?)\z/
    validates :longitude, length: { maximum: 22 }, allow_blank: true, \
              format: /\A(-|\+)?((?:1[0-7]|[1-9])?\d(?:\.\d{1,})?|180(?:\.0{1,})?)\z/

    delegate :budget, :budget_id, to: :group, allow_nil: true

    scope :allow_custom_content,  -> { where(allow_custom_content: true).sort_by(&:name) }

    def self.sort_by_name
      all.sort do |heading, other_heading|
        [other_heading.group.name, heading.name] <=> [heading.group.name, other_heading.name]
      end
    end

    def name_scoped_by_group
      group.single_heading_group? ? name : "#{group.name}: #{name}"
    end

    def can_be_deleted?
      investments.empty?
    end

    def area
      districts.sum(:area)
    end

    def population
      districts.sum(:population)
    end

    private

      def generate_slug?
        slug.nil? || budget.drafting?
      end

      def budget_resource_allocation_balloting?
        budget.resource_allocation_balloting?
      end
  end
end
