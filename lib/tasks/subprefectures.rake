namespace :subprefectures do
  desc "Create budget group headings with subprefecture and district data via CSV file"
  task create: :environment do
    if ENV['FILEPATH']
      if group = Budget::Group.where(name: "Subprefeituras").last

        rows = CSV.read(
          ENV['FILEPATH'],
          { headers: true, header_converters: :symbol, col_sep: ';' }
        )

        format_number = lambda { |number| number.gsub(",", ".").to_f }

        rows.map.with_index do |row, index|
          subprefecture = row[:subprefeitura]
          population = row[:populacao].to_i
          area = format_number.call(row[:area])

          if heading = Budget::Heading.find_by(name: subprefecture)
            heading.population += population
            heading.area += area
          else
            heading_params = {
              name: subprefecture,
              population: population,
              # latitude: format_number.call(row[:centroide_x]).to_s,
              # longitude: format_number.call(row[:centroide_y]).to_s,
              area: area,
              households: row[:domicilios_subprefeitura].to_i,
              slum_households_percentage: format_number.call(
                row[:domicilios_em_favelas_subprefeitura]
              ),
              slum_households_reference_year: 2017,
              formal_jobs_by_population: format_number.call(
                row[:emprego_por_habitante_subprefeitura]
              ),
              formal_jobs_by_population_reference_year: 2016,
              population_density: format_number.call(
                row[:densidade_populacional_subprefeitura]
              ),
              population_density_reference_year: 2019,
              hdi: format_number.call(row[:idh]),
              hdi_reference_year: 2010,
              analytical_framework_url: row[:quadro_analitico],
              action_perimeter_url: row[:perimetro_de_acao]
            }
            heading = group.headings.new(heading_params)
          end
          district_params = {
            name: row[:distrito],
            population: population,
            area: area,
            households: row[:domicilios_distrito].to_i,
            slum_households_percentage: format_number.call(
              row[:domicilios_em_favelas_distrito]
            ),
            formal_jobs_by_population: format_number.call(
              row[:emprego_por_habitante_distrito]
            ),
            population_density: format_number.call(
              row[:densidade_populacional_distrito]
            )
          }

          heading.districts.new(district_params)
          heading.save!
        end
      else
        puts "'Subprefeituras' group does not exist"
      end
    else
      puts "Set FILEPATH variable"
    end
  end
end
