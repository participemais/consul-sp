namespace :budget_proposals do
  desc "Import budget proposals via CSV file"
  task create: :environment do
    if ENV['FILEPATH']
      if group = Budget::Group.where(name: "Subprefeituras").last
        rows = CSV.read(
          ENV['FILEPATH'],
          { headers: true, header_converters: :symbol, col_sep: '|' }
        )

        rows.map.with_index(2) do |row, index|
          subprefecture = row[:subprefeitura].strip
          if heading = Budget::Heading.find_by(name: subprefecture)
            investment_params = {
              feasibility: "feasible",
              price: 1,
              author_id: 1,
              valuation_finished: true,
              heading_id: heading.id,
              budget_id: group.budget.id,
              group_id: group.id,
              selected: true,
              title: row[:titulo],
              description: row[:descricao],
              skip_map: "1",
              terms_of_service: "1",
              tag_list: [row[:categoria]]
            }

            investment = Budget::Investment.new(investment_params)

            unless investment.save
              errors = investment.errors.full_messages*(', ')
              puts "Row: #{index} - Errors: #{errors} - Subprefecture: #{subprefecture} fails"
            end
          else
            puts "Subprefecture #{subprefecture} not found "
          end
        end
      else
        puts "'Subprefeituras' group does not exist"
      end
    else
      puts "Set FILEPATH variable"
    end
  end

  desc "Set slug"
  task set_slug: :environment do
    investments = Budget::Investment.where(slug: nil)
    investments.each do |investment|
      slug = "Orçamento #{investment.budget_id} proposta #{investment.code}".parameterize
      

      unless investment.update(slug: slug)
        errors = investment.errors.full_messages*(', ')
        puts "Errors: #{errors} - Budget: #{investment.budget_id} Investment: #{investment.id}"
      end

    end
    puts "Slugs updated"
  end
end




