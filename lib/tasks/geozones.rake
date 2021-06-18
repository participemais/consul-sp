namespace :geozones do

  desc "Cria geozonas"
  task create: :environment do
    subprefectures = ["Aricanduva/Formosa/Carrão", "Butantã", "Campo Limpo",
      "Capela do Socorro", "Casa Verde", "Cidade Ademar", "Cidade Tiradentes",
      "Ermelino Matarazzo", "Freguesia/Brasilândia", "Guaianases", "Ipiranga",
      "Itaim Paulista", "Itaquera", "Jabaquara", "Jaçanã/Tremembé", "Lapa",
      "M'Boi Mirim", "Mooca", "Parelheiros", "Penha", "Perus", "Pinheiros",
      "Pirituba/Jaraguá", "Santo Amaro", "Santana/Tucuruvi", "São Mateus", "São Miguel", "Sapopemba", "Sé",
      "Vila Maria/Vila Guilherme", "Vila Mariana", "Vila Prudente"]

    subprefectures.each do |name|
      puts "Criando geozona de subprefeitura - #{name}"
      filename = name.gsub('/', '0').parameterize.underscore.upcase.gsub('0','-')
      file = File.open("lib/kml/subs/#{filename}.kml")
      parsed_kml = Nokogiri::XML(file)
      sub_name = parsed_kml.css('SimpleData[name=sp_nome]').text
      document = Document.new(title: filename, attachment: file, user: User.first)
      Geozone.create!(name: name, district: false, external_code: sub_name, document: document, active: true)
    end

    districts = ["Aricanduva", "Carrão", "Vila Formosa", "Butantã", "Morumbi",
      "Raposo Tavares", "Rio Pequeno", "Vila Sônia", "Campo Limpo", "Capão Redondo",
      "Vila Andrade", "Cidade Dutra", "Grajaú", "Socorro", "Cachoeirinha", "Casa Verde",
      "Limão", "Cidade Ademar", "Pedreira", "Cidade Tiradentes", "Ermelino Matarazzo",
      "Ponte Rasa", "Brasilândia", "Freguesia do Ó", "Guaianases", "Lajeado", "Cursino",
      "Ipiranga", "Sacomã", "Itaim Paulista", "Vila Curuçá", "Cidade Líder", "Itaquera",
      "José Bonifácio", "Parque do Carmo", "Jabaquara", "Jaçanã", "Tremembé", "Barra Funda",
      "Jaguara", "Jaguaré", "Lapa", "Perdizes", "Vila Leopoldina", "Jardim Ângela",
      "Jardim São Luís", "Água Rasa", "Belém", "Brás", "Mooca", "Pari", "Tatuapé", "Marsilac",
      "Parelheiros", "Artur Alvim", "Cangaíba", "Penha", "Vila Matilde", "Anhanguera", "Perus",
      "Alto de Pinheiros", "Itaim Bibi", "Jardim Paulista", "Pinheiros", "Jaraguá", "Pirituba",
      "São Domingos", "Mandaqui", "Santana", "Tucuruvi", "Campo Belo", "Campo Grande",
      "Santo Amaro", "Iguatemi", "São Mateus", "São Rafael", "Jardim Helena", "São Miguel",
      "Vila Jacuí", "Sapopemba", "Bela Vista", "Bom Retiro", "Cambuci", "Consolação", "Liberdade",
      "República", "Santa Cecília", "Sé", "Vila Guilherme", "Vila Maria", "Vila Medeiros", "Moema",
      "Saúde", "Vila Mariana", "São Lucas", "Vila Prudente"]

    districts.each do |name|
      puts "Criando geozona de distritos - #{name}"
      filename = name.parameterize.underscore
      file = File.open("lib/kml/districts/#{filename}.kml")
      parsed_kml = Nokogiri::XML(file)
      sub_name = parsed_kml.css('SimpleData[name=ds_subpref]').text
      subprefecture = Geozone.where(district: false).find_by(external_code: sub_name)
      document = Document.new(title: filename, attachment: file, user: User.first)
      Geozone.create!(name: name, district: true, external_code: filename, subprefecture: subprefecture, document: document, active: true)
    end
    puts "Tarefa finalizada"
  end

  desc "Atribui geozona aos usuários"
  task set: :environment do
    User.all.select(:from_sp?).each do |user|
      results = OpenStreetMapService.search(user.query_address)

      if results.count == 1
        lat = results.first['lat']
        long = results.first['lon']
        user.geozone = Geozone.sub_search(lat, long)
        user.save
      elsif results.count > 1
        @districts = Geozone.compare(results)
        
        if @districts.count == 1
          user.geozone = @districts.first
          user.save
        end
      end 
    end
  end

  desc "Conta usuários e geozonas"
  task set: :environment do
    matches_count = 0
    many_matches_count = 0
    no_matches_count = 0

    User.all.select(:from_sp?).each do |user|    
      results = OpenStreetMapService.search(user.query_address)

      if results.count == 1
        lat = results.first['lat']
        long = results.first['lon']
        user.geozone = Geozone.sub_search(lat, long)
        #user.save
        match += 1
      elsif results.count > 1
        @districts = Geozone.compare(results)
        
        if @districts.count == 1
          user.geozone = @districts.first
          #user.save
          match += 1
        elsif @districts.count > 1
          many_matches_count += 1
        end
      else
        no_matches_count += 1
      end 

      puts "Encontradas: #{matches_count}"
      puts "Mais de uma encontrada: #{many_matches_count}"
      puts "Nenhuma encontrada: #{no_matches_count}"
    end
  end
end