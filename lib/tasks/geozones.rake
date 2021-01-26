namespace :geozones do

  desc "Cria geozonas"
  task create: :environment do
    subprefectures = ["Aricanduva/Formosa/Carrão", "Butantã", "Campo Limpo",
      "Capela do Socorro", "Casa Verde/Cachoeirinha", "Cidade Ademar", "Cidade Tiradentes",
      "Ermelino Matarazzo", "Freguesia/Brasilândia", "Guaianases", "Ipiranga",
      "Itaim Paulista", "Itaquera", "Jabaquara", "Jaçanã/Tremembé", "Lapa",
      "M Boi Mirim", "Mooca", "Parelheiros", "Penha", "Perus", "Pinheiros",
      "Pirituba/Jaraguá", "Santo Amaro", "Santana/Tucuruvi", "São Mateus", "São Miguel", "Sapopemba", "Sé",
      "Vila Maria/Vila Guilherme", "Vila Mariana", "Vila Prudente"]

    subprefectures.each do |name|
      puts "Criando geozona de subprefeitura - #{name}"
      filename = name.gsub('/', '0').parameterize.underscore.upcase.gsub('0','-')
      kml_file = Nokogiri::XML(File.open("lib/kml/subs/#{filename}.kml"))
      sub_name = kml_file.css('SimpleData[name=sp_nome]').text
      Geozone.create(name: name, district: false, external_code: sub_name)
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
      kml_file = Nokogiri::XML(File.open("lib/kml/districts/#{filename}.kml"))
      sub_name = kml_file.css('SimpleData[name=ds_subpref]').text
      subprefecture = Geozone.where(district: false).find_by(external_code: sub_name)
      Geozone.create(name: name, district: true, external_code: filename, subprefecture: subprefecture)
    end
    puts "Tarefa finalizada"
  end
end