class Edition::Poll::BaseController < Edition::BaseController
	POLL_CONTROLLERS = ['booth_assignments', 'officer_assignments', 'recounts', 'electoral_colleges']
	OTHER_CONTROLLERS = ['questions', 'answers']
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
    		if POLL_CONTROLLERS.include?(controller_name) && current_user.editor.poll_ids.include?(params[:id].to_i)
    			return
    		# elsif OTHER_CONTROLLERS.include?(controller_name) && current_user.editor.poll_ids.include?(params[:poll_id].to_i) 
    		# 	return
    		# elsif OTHER_CONTROLLERS.include?(controller_name) && action_name == 'show' current_user.editor.poll_ids.include?(params[:poll_question][:poll_id].to_i) 
    			
    		# elsif OTHER_CONTROLLERS.include?(controller_name) && current_user.editor.poll_ids.include?(params[:poll_question][:poll_id].to_i) 
    		# 	return
    		else
    			raise CanCan::AccessDenied.new
    		end

    	end
    end
end
