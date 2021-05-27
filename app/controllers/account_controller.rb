class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  load_and_authorize_resource class: "User"

  def show

  end

  def update
    if @account.update(account_params)
      if @account.level_three_verified? && @account.geozone_id.blank? && @account.resident?
        results = OpenStreetMapService.search(@account.query_address)

        if results.count == 1
          lat = results.first['lat']
          long = results.first['lon']
          @account.geozone = Geozone.sub_search(lat, long)
          @account.save
        elsif results.count > 1
          if params[:address].present?
            lat = results[params[:address].to_i]['lat']
            long = results[params[:address].to_i]['lon']
            @account.geozone = Geozone.sub_search(lat, long)
            @account.save
          else
            @districts = Geozone.compare(results)
            
            if @districts.count == 1
              @account.geozone = @districts.first
              @account.save
            else
              @subs = @districts.map { |district| district.subprefecture}.uniq
              @select_from_list = true
            end
          end
        else
          @select_from_all = true
        end
      elsif !@account.resident?
        @account.update geozone_id: nil
      end
      render :show, notice: t("flash.actions.save_changes.notice")
    else
      @account.errors.messages.delete(:organization)
      render :show
    end
  end

  private

    def set_account
      @account = current_user
    end

    def account_params
      attributes = if @account.organization?
                     [:phone_number, :email_on_comment, :email_on_comment_reply, :newsletter, :cep, :home_address, :address_number,
                      :address_complement, :city, :uf,
                      organization_attributes: [:name, :responsible_name]]
                   else
                     [:username, :public_activity, :public_interests, :email_on_comment,
                      :email_on_comment_reply, :email_on_direct_message, :email_digest, :newsletter,
                      :official_position_badge, :recommended_debates, :recommended_proposals, :document_number, :document_type, :date_of_birth,
                      :gender, :ethnicity, :cep, :home_address, :address_number, :geozone_id,
                      :address_complement, :city, :uf, :first_name, :last_name, :neighbourhood
                    ]
                   end
      params.require(:account).permit(*attributes)
    end
end
