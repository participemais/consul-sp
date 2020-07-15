class Organizations::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create], honeypot: :address, scope: :user

  def new
    super(&:build_organization)
  end

  def success
  end

  def create
    build_resource(sign_up_params)
    if resource.valid?
      super do |user|
        # Removes unuseful "organization is invalid" error message
        user.errors.messages.delete(:organization)
      end
    else
      render :new
    end
  end

  protected

    def after_inactive_sign_up_path_for(resource)
      organizations_sign_up_success_path
    end

  private

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   organization_attributes: [:name, :responsible_name])
    end
end
