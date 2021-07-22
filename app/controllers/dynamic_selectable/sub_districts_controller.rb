class DynamicSelectable::SubDistrictsController < DynamicSelectable::SelectController
	def index
	  districts = Geozone.where(subprefecture_id: params[:geozone_id], district: true, active: true).select('id, name').order('name asc')
	  render json: districts
	end
end

