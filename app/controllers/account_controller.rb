class AccountController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_geozone, only: :update

  load_and_authorize_resource class: "User"

  def show

  end

  def update    
    if @account.update(account_params)
      render :show, notice: t("flash.actions.save_changes.notice")
    else
      @account.errors.messages.delete(:organization)
      render :show
    end
  end

  private

    def set_geozone
      @account.assign_attributes(account_params)

      if @account.address_changeable? && account_params[:district_id].blank? && @account.level_three_verified? && @account.from_sp? && ( @account.cep_changed? || @account.geozone == nil )
        results = OpenStreetMapService.search(@account.query_address)

        if results.count == 1
          lat = results.first['lat']
          long = results.first['lon']
          @account.update geozone: Geozone.sub_search(lat, long)
        elsif results.count > 1
          @districts = Geozone.compare(results)
          
          if @districts.count == 1
            @account.update geozone: @districts.first
          elsif @districts.count > 1
            @subs = @districts.map { |district| district.subprefecture}.uniq
            @select_from_list = true
            @account.update geozone: nil
          else 
            @select_from_all = true
            @account.update geozone: nil
          end
        else
          @select_from_all = true
          @account.update geozone: nil
        end
      elsif @account.address_changeable? && !@account.from_sp?
        @account.geozone = nil
      elsif !@account.address_changeable?
        @account.restore_attributes
        flash.now[:alert] = "Não é permitido atualizar dados de endereço dentro de um intervalo de 30 dias."
        return render :show
      end
    end

    def set_account
      @account = current_user
    end

    def account_params
      attributes = if @account.organization?
                     [:phone_number, :email_on_comment, :email_on_comment_reply, :newsletter, :cep, :home_address, :address_number,
                      :address_complement, :city, :uf, :district_id,
                      organization_attributes: [:name, :responsible_name]]
                   else
                     [:username, :public_activity, :public_interests, :email_on_comment,
                      :email_on_comment_reply, :email_on_direct_message, :email_digest, :newsletter,
                      :official_position_badge, :recommended_debates, :recommended_proposals, :document_number, :document_type, :date_of_birth,
                      :gender, :ethnicity, :cep, :home_address, :address_number, :district_id,
                      :address_complement, :city, :uf, :first_name, :last_name, :neighbourhood
                    ]
                   end
      params.require(:account).permit(*attributes)
    end
end
