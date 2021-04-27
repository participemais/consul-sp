class OpenStreetMapService
	def self.search address
		url_address = ERB::Util.url_encode(address)
		response = `curl "https://nominatim.openstreetmap.org/?street=#{url_address}&city=s%C3%A3o%20paulo&format=json&addressdetails=1"`
		result = JSON.parse response
		result.select { |r| r['address']['city'] == 'São Paulo' }
	end
end
