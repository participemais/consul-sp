module Admin::Polls::ElectorsHelper
  def options_for_document_type
    User::DOCUMENT_TYPES.map(&:upcase)
  end
end
