class Legislation::DraftVersion::Exporter
  require "csv"

  include ExporterSpreadsheet

  def initialize(draft_version)
    @draft_version = draft_version
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ANNOTATION_COLUMNS.map { |column| header_translation(column) }

      @draft_version.annotations.each do |annotation|
        csv << csv_row(@draft_version, annotation)
      end
    end
  end

  private

  ANNOTATION_COLUMNS = %w(id title text comment user).freeze


  def csv_row(draft_version, annotation)
    [
      draft_version.id.to_s,
      draft_version.title,
      sanitize_description(annotation.context),
      annotation.text,
      annotation.author.name
    ]
  end

  def header_translation(key)
    I18n.t(key, scope: 'legislation.draft_versions.spreedsheet')
  end
end
