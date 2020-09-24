module Admin::LegislationTopicsHelper
  def document_link
    if @process.topics.any?
      t("admin.legislation.topics.index.edit")
    else
      t("admin.legislation.topics.index.create")
    end
  end
end
