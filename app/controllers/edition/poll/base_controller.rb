class Edition::Poll::BaseController < Edition::BaseController
  helper_method :namespace

  private

    def namespace
    	if current_user.administrator?
      	"admin"
      elsif current_user.editor?
      	"edition"
      end
    end
end
