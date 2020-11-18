module ExporterSpreadsheet
  extend ActiveSupport::Concern

  def sanitize_description(description)
    Nokogiri::HTML.parse(description).text.squish
  end
end
