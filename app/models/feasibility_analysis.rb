class FeasibilityAnalysis < ApplicationRecord
  belongs_to :feasibility_analyzable, polymorphic: true
  belongs_to :department
  validates :feasibility_analyzable, presence: true
  validates :department_id, presence: true
  validates :department_id, uniqueness: { scope: :feasibility_analyzable_id }

  delegate :name, to: :department, prefix: true

  ANALYSES_FIELDS = %i(technical legal budgetary)

  def analysis_fields
    ANALYSES_FIELDS.reject { |field| send(field) == 'undecided' }
  end

  def should_show_codes?
    sei_number.present? || budgetary_actions.present?
  end

  AGENCIES = [
    "Secretaria Municipal de Direitos Humanos e Cidadania",
    "Secretaria Municipal de Educação",
    "Secretaria Municipal de Esportes e Lazer",
    "Secretaria Municipal de Fazenda",
    "Secretaria Municipal de Gestão",
    "Secretaria Municipal de Governo",
    "Secretaria Municipal de Habitação",
    "Secretaria Municipal de Infraestrutura e Obras",
    "Secretaria Municipal de Inovação e Tecnologia",
    "Secretaria Municipal de Justiça",
    "Secretaria Municipal de Licenciamento",
    "Secretaria Municipal de Mobilidade e Transportes",
    "Secretaria Municipal da Pessoa com Deficiência",
    "Procuradoria Geral do Município",
    "Secretaria Municipal de Relações Sociais",
    "Secretaria Municipal da Saúde",
    "Secretaria Municipal de Segurança Urbana",
    "Secretaria Municipal de Subprefeituras",
    "Secretaria Municipal de Turismo",
    "Secretaria Municipal do Verde e do Meio Ambiente"
  ]
end
