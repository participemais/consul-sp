class Poll::Electors::Exporter
  require "csv"

  def initialize(electors)
    @electors = electors
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ELECTOR_COLUMNS.map { |column| header_translation(column) }
      @electors.each do |elector|
        csv << csv_row(elector)
      end
    end
  end

  private

  ELECTOR_COLUMNS = %w(
    id document_type document_number category user_found
  ).freeze

  def csv_row(elector)
    [
      elector.id.to_s,
      elector.document_type,
      elector.document_number,
      elector.category,
      yes_or_no(elector.user_found)
    ]
  end

  def yes_or_no(condition)
    condition ? I18n.t("shared.yes") : I18n.t("shared.no")
  end

  def header_translation(key)
    I18n.t(key, scope: 'admin.poll_electors.export.spreadsheet')
  end
end
