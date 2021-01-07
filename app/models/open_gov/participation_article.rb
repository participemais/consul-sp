class OpenGov::ParticipationArticle < ApplicationRecord
  include Documentable

  accepts_nested_attributes_for :documents, allow_destroy: true
end
