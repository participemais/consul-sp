module DynamicSelectable
  class SubDisctrictsController < SelectController
    def index
      districts = Geozone.where(geozone_id: params[:geozone_id], district: true).select('id, name').order('name asc')
      render json: districts
    end
  end
end
