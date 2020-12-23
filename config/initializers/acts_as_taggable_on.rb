module ActsAsTaggableOn
  Tagging.class_eval do
    after_create :increment_tag_custom_counter
    after_destroy :touch_taggable, :decrement_tag_custom_counter

    scope :public_for_api, -> do
      where(%{taggings.tag_id in (?) and
              (taggings.taggable_type = 'Debate' and taggings.taggable_id in (?)) or
              (taggings.taggable_type = 'Proposal' and taggings.taggable_id in (?))},
            Tag.where("kind IS NULL or kind = ?", "category").pluck(:id),
            Debate.public_for_api.pluck(:id),
            Proposal.public_for_api.pluck(:id))
    end

    def touch_taggable
      taggable.touch if taggable.present?
    end

    def increment_tag_custom_counter
      tag.increment_custom_counter_for(taggable_type)
    end

    def decrement_tag_custom_counter
      tag.decrement_custom_counter_for(taggable_type)
    end
  end

  Tag.class_eval do
    clear_validators!
    validates_presence_of :name
    validates_uniqueness_of :name, if: :validates_name_uniqueness?, case_sensitive: true, scope: :kind
    validates_length_of :name, maximum: 255

    # monkey patch this method if don't need name uniqueness validation
    def validates_name_uniqueness?
      true
    end

    scope :category, -> { where(kind: "category") }
    scope :subprefecture, -> { where(kind: "subprefecture") }
    scope :district, -> { where(kind: "district") }

    def subprefecture?
      kind == "subprefecture"
    end

    def category?
      kind == "category"
    end

    def district?
      kind == "district"
    end

    include Graphqlable

    scope :public_for_api, -> do
      where("(tags.kind IS NULL or tags.kind = ?) and tags.id in (?)",
            ["category", "subprefecture", "district"],
            Tagging.public_for_api.pluck("DISTINCT taggings.tag_id"))
    end

    include PgSearch



    pg_search_scope :pg_search, against: :name,
                                using: {
                                  tsearch: { prefix: true }
                                },
                                ignoring: :accents

    def self.search(term)
      pg_search(term)
    end

    def increment_custom_counter_for(taggable_type)
      Tag.increment_counter(custom_counter_field_name_for(taggable_type), id)
    end

    def decrement_custom_counter_for(taggable_type)
      Tag.decrement_counter(custom_counter_field_name_for(taggable_type), id)
    end

    def self.category_names
      Tag.category.pluck(:name)
    end

    def self.subprefecture_names
      Tag.subprefecture.pluck(:name)
    end

    def self.district_names
      Tag.district.pluck(:name)
    end

    def self.graphql_field_name
      :tag
    end

    def self.graphql_pluralized_field_name
      :tags
    end

    def self.graphql_type_name
      "Tag"
    end

    private

      def custom_counter_field_name_for(taggable_type)
        "#{taggable_type.underscore.pluralize}_count"
      end
  end
end
