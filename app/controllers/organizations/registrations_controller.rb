class Organizations::RegistrationsController < Devise::RegistrationsController
  invisible_captcha only: [:create], honeypot: :address, scope: :user
  # prepend_before_action :check_captcha, only: [:create]

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

    def check_captcha
      unless verify_recaptcha(timeout: 60)
        flash.delete(:recaptcha_error)
        build_resource(sign_up_params)
        resource.valid?
        resource.errors.add(:base, t('errors.messages.recaptcha_error'))
        clean_up_passwords(resource)
        respond_with_navigational(resource) { render :new }
      end
    end
end
