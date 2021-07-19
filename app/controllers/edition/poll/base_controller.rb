class Edition::Poll::BaseController < Edition::BaseController
	CONTROLLERS = ['booth_assignments', 'officer_assignments', 'recounts', 'electoral_colleges']
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
    	byebug
    	if current_user.editor? 
    		return if controller_name == 'polls' && action_name == 'index'
    		
    		if !current_user.editor.poll_ids.include?(params[:id].to_i) && !CONTROLLERS.include?(controller_name)
    			raise CanCan::AccessDenied.new
    		end
    	end
    end
end
