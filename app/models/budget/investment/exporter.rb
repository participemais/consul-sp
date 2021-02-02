class Budget::Investment::Exporter
  require "csv"

  include ExporterSpreadsheet

  def initialize(investments, budget)
    @investments = investments
    @budget = budget
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << headers
      @investments.each { |investment| csv << csv_values(investment) }
    end
  end

  def proposals_list_csv
    CSV.generate(headers: true) do |csv|
      csv << proposals_list_headers
      @investments.each do |investment|
        @image_url = ''
        @documents = ['', '', '']
        documents_url(investment.documents)
        image_url(investment.image)
        csv << proposals_list_csv_values(investment)
      end
    end
  end

  private

    PROPOSALS_COLUMNS = %w(id created_at author subprefecture title description categories image_url first_document second_document third_document prioritization votes balloting_result feasibility commitment unfeasibility_explanation).freeze

    FEASIBILITY_COLUMNS = %w(department budgetary_actions sei_number technical technical_description legal legal_description budgetary budgetary_description).freeze

    def proposals_list_headers
      headers = PROPOSALS_COLUMNS.map { |column| header_translation(column) }

      if @budget.devolutive_or_later? &&
        max_analyses_count = @investments.max_feasibility_analyses_count

        (1..max_analyses_count).each do |counter|
          FEASIBILITY_COLUMNS.each do |column|
            headers << "#{header_translation(column)} (#{counter})"
          end
        end
      end

      headers
    end

    def proposals_list_csv_values(investment)
      row = [
        investment.id.to_s,
        I18n.l(investment.created_at.to_date),
        investment.author.name,
        investment.heading_name,
        investment.title,
        sanitize_description(investment.description),
        investment.tag_list.join(', '),
        @image_url,
        @documents.first,
        @documents.second,
        @documents.third,
        priorization(investment),
        votes(investment),
        balloting_result(investment),
        feasibility(investment),
        commitment(investment),
        unfeasibility_explanation(investment)
      ]

      if @budget.devolutive_or_later?
        investment.feasibility_analyses.each do |analysis|
          feasibility_row = [
            analysis.department_name,
            analysis.budgetary_actions,
            analysis.sei_number,
            feasibility_translation(analysis.technical),
            sanitize_description(analysis.technical_description),
            feasibility_translation(analysis.legal),
            sanitize_description(analysis.legal_description),
            feasibility_translation(analysis.budgetary),
            sanitize_description(analysis.budgetary_description)
          ]
          row += feasibility_row
        end
      end

      row
    end

    def image_url(image)
      @image_url = image.url if image.present?
    end

    def documents_url(documents)
      if documents.present?
        documents.each_with_index do |document, index|
          @documents[index] = document.url
        end
      end
    end

    def priorization(investment)
      return prioritized_or_not(investment.selected?) if @budget.balloting_or_later?

      phase_default_message
    end

    def votes(investment)
      return investment.ballot_lines_count if @budget.publishing_prices_or_later?

      phase_default_message
    end

    def balloting_result(investment)
      return elected_or_not(investment.winner?) if @budget.publishing_prices_or_later?

      phase_default_message
    end

    def feasibility(investment)
      return feasibility_translation(investment.feasibility) if @budget.devolutive_or_later?

      phase_default_message
    end

    def commitment(investment)
      return sanitize_description(investment.commitment) if @budget.devolutive_or_later?

      phase_default_message
    end

    def unfeasibility_explanation(investment)
      return sanitize_description(investment.unfeasibility_explanation) if @budget.devolutive_or_later?

      phase_default_message
    end

    def phase_default_message
      I18n.t('budgets.investments.index.spreadsheet.default_message')
    end

    def headers
      [
        I18n.t("admin.budget_investments.index.list.id"),
        I18n.t("admin.budget_investments.index.list.title"),
        I18n.t("admin.budget_investments.index.list.supports"),
        I18n.t("admin.budget_investments.index.list.admin"),
        I18n.t("admin.budget_investments.index.list.valuator"),
        I18n.t("admin.budget_investments.index.list.valuation_group"),
        I18n.t("admin.budget_investments.index.list.geozone"),
        I18n.t("admin.budget_investments.index.list.feasibility"),
        I18n.t("admin.budget_investments.index.list.valuation_finished"),
        I18n.t("admin.budget_investments.index.list.selected"),
        I18n.t("admin.budget_investments.index.list.visible_to_valuators"),
        I18n.t("admin.budget_investments.index.list.author_username")
      ]
    end

    def csv_values(investment)
      [
        investment.id.to_s,
        investment.title,
        investment.total_votes.to_s,
        admin(investment),
        investment.assigned_valuators || "-",
        investment.assigned_valuation_groups || "-",
        investment.heading.name,
        price(investment),
        yes_or_no(investment.valuation_finished?),
        yes_or_no(investment.selected?),
        yes_or_no(investment.visible_to_valuators?),
        investment.author.username
      ]
    end

    def admin(investment)
      if investment.administrator.present?
        investment.administrator.name
      else
        I18n.t("admin.budget_investments.index.no_admin_assigned")
      end
    end

    def price(investment)
      price_string = "admin.budget_investments.index.feasibility.#{investment.feasibility}"
      if investment.feasible?
        "#{I18n.t(price_string)} (#{investment.formatted_price})"
      else
        I18n.t(price_string)
      end
    end

    def yes_or_no(condition)
      condition ? I18n.t("shared.yes") : I18n.t("shared.no")
    end

    def prioritized_or_not(condition)
      if condition
        investment_translation(:prioritized)
      else
        investment_translation(:not_prioritized)
      end
    end

    def elected_or_not(condition)
      if condition
        investment_translation(:elected)
      else
        investment_translation(:not_elected)
      end
    end

    def investment_translation(key)
      I18n.t(key, scope: "budgets.investments.investment")
    end

    def feasibility_translation(key)
      I18n.t(key, scope: "shared")
    end

    def header_translation(key)
      I18n.t(key, scope: 'budgets.investments.index.spreadsheet')
    end
end
