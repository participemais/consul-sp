class Edition::BaseController < ApplicationController
  layout "admin"

  before_action :authenticate_user!
  before_action :verify_editor

  skip_authorization_check

  helper_method :namespace

  private
    def verify_editor
      raise CanCan::AccessDenied unless current_user&.administrator? || current_user&.editor?
    end

    def namespace
    	if current_user.administrator?
    		"admin"
    	elsif current_user.editor?
      	"edition"
      end
    end
end
