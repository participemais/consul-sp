module Admin::Polls::Electors::ImportsHelper
  def errors_for(resource, field)
    if resource.errors.include? field
      tag.div class: "error" do
        resource.errors[field].join(", ")
      end
    end
  end

  def electors_import_required_headers
    Poll::Electors::Import::ATTRIBUTES.to_sentence(last_word_connector: " e ")
  end
end
