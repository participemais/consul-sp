class DeviseMailer < Devise::Mailer
  helper :application, :settings
  include Devise::Controllers::UrlHelpers
  default template_path: "devise/mailer"

  def confirmation_instructions(record, token, opts = {})
    @username = record.username
    @participation_processes = participation_processes
    super
  end

  private

    def participation_processes
      Budget.balloting + Poll.current
    end

  protected

    def devise_mail(record, action, opts = {})
      I18n.with_locale record.locale do
        super(record, action, opts)
      end
    end
end
