class Edition::Poll::BaseController < Edition::BaseController
  helper_method :namespace

  before_action :authorize_editor

  private

    def namespace
    	if current_user.administrator?
      	"admin"
      elsif current_user.editor?
      	"edition"
      end
    end

    def authorize_editor
    	if current_user.editor? 
    		return if controller_name == 'polls' && action_name == 'index'
    		byebug
    		if !current_user.editor.poll_ids.include?(params[:id].to_i)
    			raise CanCan::AccessDenied.new
    		end
    	end
    end
end
