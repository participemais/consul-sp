require "csv"

class Poll::Elector::Import
  include ActiveModel::Model

  ATTRIBUTES = %w[document_type document_number category].freeze
  ALLOWED_FILE_EXTENSIONS = %w[csv].freeze

  attr_accessor :file

  validates :file, presence: true
  validate :file_extension, if: -> { @file.present? }

  def initialize(attributes = {})
    if attributes.present?
      attributes.each do |attr, value|
        public_send("#{attr}=", value)
      end
    end
  end

  private

    def file_extension
      return if valid_extension?

      errors.add :file, :extension, valid_extensions: ALLOWED_FILE_EXTENSIONS.join(", ")
    end

    def valid_extension?
      ALLOWED_FILE_EXTENSIONS.include? extension
    end

    def extension
      File.extname(file.original_filename).delete(".")
    end
end
