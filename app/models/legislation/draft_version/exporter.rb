class Legislation::DraftVersion::Exporter
  require "csv"

  include ExporterSpreadsheet

  def initialize(draft_version)
    @draft_version = draft_version
  end

  def to_csv
    CSV.generate(headers: true) do |csv|

      if @draft_version.annotations.empty?
        csv << NO_ANNOTATION_COLUMNS.map { |column| header_translation(column) }
        csv << csv_row(@draft_version)
      else
        csv << ANNOTATION_COLUMNS.map { |column| header_translation(column) }

        @draft_version.annotations.each do |annotation|
          annotation.comments.each do |comment|
            csv << annotation_csv_row(@draft_version, annotation, comment.body)
          end
        end
      end
    end
  end

  private


  ANNOTATION_COLUMNS = %w(id title text comment user).freeze
  NO_ANNOTATION_COLUMNS = %w(id title comment).freeze


  def annotation_csv_row(draft_version, annotation, comment)
    [
      draft_version.id.to_s,
      draft_version.title,
      sanitize_description(annotation.context),
      comment,
      annotation.author.name
    ]
  end

    def csv_row(draft_version)
    [
      draft_version.id.to_s,
      draft_version.title,
      no_comments,
    ]
  end

  def no_comments
    I18n.t("legislation.draft_versions.spreedsheet.no_comments")
  end

  def header_translation(key)
    I18n.t(key, scope: 'legislation.draft_versions.spreedsheet')
  end
end
