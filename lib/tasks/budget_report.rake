require "csv"

namespace :budget_report do

  desc "Gera relatório de orçamento de São Mateus"
  task generate: :environment do
    budget_report = BudgetReport.new
    File.open('relatorio_votos_sao_mateus.csv', 'w') { |file| file.write(budget_report.proposals_list_csv) }
  end


  class BudgetReport
    PROPOSALS_COLUMNS = %w(code created_at author subprefecture title description categories image_url first_document second_document third_document prioritization votes balloting_result feasibility commitment unfeasibility_explanation).freeze
    
    def initialize
      @budget = Budget.find(2)
      @heading = Budget::Heading.find(92)
      @investments = Budget::Investment.where(budget: @budget, heading: @heading).order(:cached_votes_up => :desc)
    end

    def proposals_list_csv
      CSV.generate(headers: true) do |csv|
        csv << proposals_list_headers
        @investments.each do |investment|
          @image_url = ''
          @documents = ['', '', '']
          documents_url(investment.documents)
          image_url(investment.image)
          votes = Budget::Ballot::Line.where budget: @budget, heading: @heading, investment: investment
          votes.each do |vote|
            csv << proposals_list_csv_values(investment, vote)
          end
        end
      end
    end

    def proposals_list_headers
      headers = PROPOSALS_COLUMNS.map { |column| header_translation(column) }
      headers << 'Data do voto'
      headers << 'Horário'
    end

    def header_translation(key)
      I18n.t(key, scope: 'budgets.investments.index.spreadsheet')
    end

    def proposals_list_csv_values(investment, vote)
      code = investment.code.present? ? investment.code : investment.id

      row = [
        code,
        I18n.l(investment.created_at.to_date),
        investment.author.name,
        investment.heading_name,
        investment.title,
        Nokogiri::HTML.parse(investment.description).text.squish,
        investment.tag_list.join(', '),
        @image_url,
        @documents.first,
        @documents.second,
        @documents.third,
        priorization(investment),
        votes_total(investment),
        balloting_result(investment),
        feasibility(investment),
        commitment(investment),
        unfeasibility_explanation(investment),
        vote.updated_at.strftime('%d/%m/%y'),
        vote.updated_at.strftime('%H:%M')
      ]

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

    def votes_total(investment)
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

  end
end