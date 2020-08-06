require "csv"

namespace :export do
  desc "Export users data to a csv file"
  task users_data: :environment do
    csv_options = { col_sep: ';', force_quotes: true, quote_char: '"', headers: true }
    filepath = Rails.root.join('tmp', 'dados_usuarios.csv')
    headers = %w(Idade Gênero Raça Documento CEP Endereço Número Complemento Cidade UF Voto1 Subprefeitura1 Voto2 Subprefeitura2 Voto3 Subprefeitura3 Voto4 Subprefeitura4 Voto5 Subprefeitura5 Comentários)

    t = lambda { |key| I18n.t(key, scope: 'activerecord.attributes.user') }

    users = User.active.sample(5)

    CSV.open(filepath, 'wb', csv_options) do |csv|
      csv << headers
      users.each do |user|
        row = []

        row << user.age

        if user.gender.present?
          row << t.call("gender_options.#{u.gender}")
        else
          row << ""
        end
      end
    end

  end
end