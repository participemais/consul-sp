require "csv"

class Budget::Group::Import
  include ActiveModel::Model

  ATTRIBUTES = %w[distrito subprefeitura populacao area desc_distrito desc_subprefeitura].freeze
  SUB_ATTRS = { subprefeitura: 'name', populacao: 'population', area: 'area', desc_subprefeitura: 'description' }
  DISTRICT_ATTRS = { distrito: 'name', populacao: 'population', area: 'area', desc_distrito: 'description' }
  ALLOWED_FILE_EXTENSIONS = %w[tsv].freeze

  attr_accessor :file, :group

  validates :file, presence: true
  validate :file_extension, if: -> { @file.present? }
  validate :file_headers_definition, if: -> { @file.present? && valid_extension? }

  def initialize(params = nil, group_id = nil)
    @file = params[:file] if params.present?
    @group = Budget::Group.find group_id if group_id.present?
  end

  def save
    return false if invalid?
    @group.headings.destroy_all
    
    CSV.open(file.path, headers: true, :col_sep => "\t").each do |row|
      next if empty_row?(row)
      process_row row
    end
    true
  end

  def save!
    validate! && save
  end


  private

    def process_row(row)
      heading = build_heading(row)
    end

    def build_heading(row)
      attrs = row.to_hash.slice(*ATTRIBUTES)
  
      sub = @group.headings.find_by(name: attrs['subprefeitura'], group_id: group.id)
      if sub.present?
        sub.area += BigDecimal.new attrs['area']
        sub.population += BigDecimal.new attrs['populacao']
        sub.save
      else
        sub = Budget::Heading.new(db_attrs attrs, SUB_ATTRS)
        @group.headings << sub
      end

      sub.districts << Budget::District.new(db_attrs attrs, DISTRICT_ATTRS)
    end

    def db_attrs attrs, hash_attrs
      result = Hash.new
      attrs.each do |k, v|
        result[hash_attrs[k.to_sym]] = attrs[k] if hash_attrs[k.to_sym].present?
      end
      result
    end

    def empty_row?(row)
      row.all? { |_, cell| cell.nil? }
    end

    def file_extension
      return if valid_extension?

      errors.add :file, :extension, valid_extensions: ALLOWED_FILE_EXTENSIONS.join(", ")
    end

    def fetch_file_headers
      CSV.open(file.path, :col_sep => "\t", &:readline)
    end

    def file_headers_definition
      headers = fetch_file_headers
      return if headers.all? { |header| ATTRIBUTES.include? header } &&
        ATTRIBUTES.all? { |attr| headers.include? attr }

      errors.add :file, :headers, required_headers: ATTRIBUTES.join(", ")
    end

    def valid_extension?
      ALLOWED_FILE_EXTENSIONS.include? extension
    end

    def extension
      File.extname(file.original_filename).delete(".")
    end
end
