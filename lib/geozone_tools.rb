class GeozoneTools
	SUBS = ["Aricanduva/Formosa/Carrão", "Butantã", "Campo Limpo", "Capela do Socorro", "Casa Verde/Cachoeirinha", "Cidade Ademar", "Cidade Tiradentes", "Ermelino Matarazzo", "Freguesia/Brasilândia", "Guaianases", "Ipiranga", "Itaim Paulista", "Itaquera", "Jabaquara", "Jaçanã/Tremembé", "Lapa", "M'Boi Mirim", "Mooca", "Parelheiros", "Penha", "Perus", "Pinheiros", "Pirituba/Jaraguá", "Santana/Tucuruvi", "Santo Amaro", "São Mateus", "São Miguel Paulista", "Sapopemba", "Sé", "Vila Maria/Vila Guilherme", "Vila Mariana", "Vila Prudente"].freeze
	DISTRICTS = ["Água Rasa", "Alto de Pinheiros", "Anhangüera", "Aricanduva", "Artur Alvim", "Barra Funda", "Bela Vista", "Belém", "Bom Retiro", "Brasilândia", "Brás", "Butantã", "Cachoeirinha", "Cambuci", "Campo Belo", "Campo Grande", "Campo Limpo", "Cangaíba", "Capão Redondo", "Carrão", "Casa Verde", "Cidade Ademar", "Cidade Dutra", "Cidade Líder", "Cidade Tiradentes", "Consolação", "Cursino", "Ermelino Matarazzo", "Freguesia do Ó", "Grajaú", "Guaianases", "Iguatemi", "Ipiranga", "Itaim Bibi", "Itaim Paulista", "Itaquera", "Jabaquara", "Jaçanã", "Jaguara", "Jaguaré", "Jaraguá", "Jardim Helena", "Jardim Paulista", "Jardim São Luís", "Jardim Ângela", "José Bonifácio", "Lajeado", "Lapa", "Liberdade", "Limão", "Mandaqui", "Marsilac", "Moema", "Mooca", "Morumbi", "Parelheiros", "Pari", "Parque do Carmo", "Pedreira", "Penha", "Perdizes", "Perus", "Pinheiros", "Pirituba", "Ponte Rasa", "Raposo Tavares", "República", "Rio Pequeno", "Sacomã", "Santa Cecília", "Santana", "Santo Amaro", "São Domingos", "São Mateus", "São Miguel Paulista", "São Lucas", "São Rafael", "Saúde", "Sapopemba", "Sé", "Socorro", "Tatuapé", "Tremembé", "Tucuruvi", "Vila Andrade", "Vila Curuçá", "Vila Formosa", "Vila Guilherme", "Vila Jacuí", "Vila Leopoldina", "Vila Maria", "Vila Mariana", "Vila Matilde", "Vila Medeiros", "Vila Prudente", "Vila Sônia"].freeze

	attr_accessor :region

	def load_region region
		self.region = BorderPatrol.parse_kml(File.read "#{region}.kml")
	end

	def has? lat,long
		self.region.contains_point?(BorderPatrol::Point.new(long.to_f, lat.to_f))
	end

	def self.search address
		OpenStreetMap::Client.new.search(q: address, format: 'json')
	end

	def self.sub_search (lat, long)
		SUBS.each do |sub|
			filename = sub.gsub('/', '0').parameterize.underscore.upcase.gsub('0','-')
			tools = GeozoneTools.new
			tools.load_region "lib/kml/subs/" + filename
			if tools.has?(lat, long)
			 	subprefecture = Geozone.where(district: false).select do |geozone| 
	        geozone.name.parameterize.underscore == sub_name
	      end
	      subprefecture.first.districts.each do |district|
	      	district_filename = district.parameterize.underscore.gsub('/', '-')
	      	district_tools = GeozoneTools.new
	      	district_tools.load_region "lib/kml/districts/" + district_filename
	      	if district_tools.has lat, long
	      		return Geozone.where(district: true).select do |geozone| 
			        geozone.name.parameterize.underscore == district_name
			      end.first
	      	end
	      end
    	end
		end
		return nil
	end
end
