class Edition::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
#  before_action :verify_editor

  skip_authorization_check

  helper_method :namespace

  private

    def namespace
    	if current_user.administrator?
    		"admin"
    	elsif current_user.editor?
      	"edition"
      end
    end

    def verify_editor
      raise CanCan::AccessDenied unless current_user&.editor? || current_user&.administrator?
    end
end
