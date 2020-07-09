class Users::RegistrationsController < Devise::RegistrationsController
  prepend_before_action :authenticate_scope!, only: [:edit, :update, :destroy, :finish_signup, :do_finish_signup]
  # prepend_before_action :check_captcha, only: [:create]
  before_action :configure_permitted_parameters

  invisible_captcha only: [:create], honeypot: :address, scope: :user

  def new
    super do |user|
      user.use_redeemable_code = true if params[:use_redeemable_code].present?
    end
  end

  def create
    build_resource(sign_up_params)
    if resource.valid?
      super
    else
      render :new
    end
  end

  def delete_form
    build_resource({})
  end

  def delete
    current_user.erase(erase_params)
    sign_out
    redirect_to root_path, notice: t("devise.registrations.destroyed")
  end

  def success
  end

  def finish_signup
    current_user.registering_with_oauth = false
    current_user.email = current_user.oauth_email if current_user.email.blank?
    current_user.validate
  end

  def do_finish_signup
    current_user.registering_with_oauth = false
    if current_user.update(sign_up_params)
      current_user.send_oauth_confirmation_instructions
      sign_in_and_redirect current_user, event: :authentication
    else
      render :finish_signup
    end
  end

  def check_username
    scope = "devise_views.users.registrations.new"
    user_check = { available: false }
    user_check[:message] =
      if strip_username.size < 3
        t("username_is_too_short", scope: scope)
      elsif User.find_by("username ilike ?", strip_username)
        t("username_is_not_available", scope: scope)
      else
        user_check[:available] = true
        t("username_is_available", scope: scope)
      end
    render json: user_check
  end

  private

    def sign_up_params
      params[:user].delete(:redeemable_code) if params[:user].present? && params[:user][:redeemable_code].blank?
      params.require(:user).permit(:username, :email, :password,
                                   :password_confirmation, :locale,
                                   :redeemable_code)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:email])
    end

    def erase_params
      params.require(:user).permit(:erase_reason, :erase_reason_description)
    end

    def after_inactive_sign_up_path_for(resource_or_scope)
      users_sign_up_success_path
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

    def strip_username
      params[:username].strip
    end
end
