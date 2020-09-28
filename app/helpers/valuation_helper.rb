module ValuationHelper
  def explanation_field(field)
    Nokogiri::HTML.parse(field).text.squish if field.present?
  end
end
