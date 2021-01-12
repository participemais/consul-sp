class Edition::Legislation::BaseController < Edition::BaseController
  include FeatureFlags

  feature_flag :legislation

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
