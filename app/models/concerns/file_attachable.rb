module FileAttachable
  extend ActiveSupport::Concern

  included do
    has_one :document, as: :documentable, inverse_of: :documentable, dependent: :destroy
    accepts_nested_attributes_for :document, allow_destroy: true
  end

  module ClassMethods
    def max_documents_allowed
      1
    end

    def max_file_size
      3.megabytes
    end

    def accepted_content_types
      ["application/xml"]
    end
  end
end
