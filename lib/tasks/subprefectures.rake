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
          slum_households = row[:domicilios_em_favelas].to_i
          extreme_poverty = row[:extrema_pobreza].to_i

          if heading = Budget::Heading.find_by(name: subprefecture)
            heading.population += population
            heading.area += area
            heading.slum_households += slum_households
            heading.extreme_poverty += extreme_poverty
          else
            heading_params = {
              name: subprefecture,
              population: population,
              # latitude: format_number.call(row[:centroide_x]).to_s,
              # longitude: format_number.call(row[:centroide_y]).to_s,
              area: area,
              slum_households: slum_households,
              slum_households_reference_year: 2017,
              extreme_poverty: extreme_poverty,
              extreme_poverty_reference_year: 2018,
              formal_jobs_by_population: format_number.call(
                row[:emprego_por_habitante_subprefeitura]
              ),
              formal_jobs_by_population_reference_year: 2016,
            }
            heading = group.headings.new(heading_params)
          end
          district_params = {
            name: row[:distrito],
            population: population,
            area: area,
            slum_households: slum_households,
            extreme_poverty: extreme_poverty,
            formal_jobs_by_population: format_number.call(
              row[:emprego_por_habitante_distrito]
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
