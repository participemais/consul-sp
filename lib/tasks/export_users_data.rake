namespace :export do
  desc "Export users data to a csv file"
  task users_data: :environment do
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"', headers: true }
    filepath = Rails.root.join('tmp', 'dados_usuarios.csv')
    headers = %w(Comentários Idade Gênero Raça Documento CEP Endereço Número Complemento Cidade UF Voto1 Subprefeitura1 Voto2 Subprefeitura2 Voto3 Subprefeitura3 Voto4 Subprefeitura4 Voto5 Subprefeitura5)

    t = lambda { |key| I18n.t(key, scope: 'activerecord.attributes.user') }

    CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << headers

      User.all.each do |user|
        row = [user.comments.count]

        if user.can_vote?
          row << user.age
          row << t.call("gender_options.#{user.gender}")
          row << t.call("ethnicity_options.#{user.ethnicity}")
          row << user.document_type
          row << user.cep
          row << user.home_address
          row << user.address_number
          row << user.address_complement
          row << user.city
          row << user.uf
          if ballot = Budget::Ballot.find_by_user_id(user)
            ballot.lines.each do |line|
              row << line.investment_id
              row << line.heading.name
            end
          end
        end

        csv << row
      end
    end
  end
end
