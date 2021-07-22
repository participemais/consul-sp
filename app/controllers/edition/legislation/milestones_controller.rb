class Edition::Legislation::MilestonesController < Edition::MilestonesController
  include FeatureFlags
  feature_flag :legislation

  load_and_authorize_resource :process, class: "Legislation::Process"

  before_action :authorize_editor

  def index
    @process = milestoneable
  end

  private

    def authorize_editor
      if current_user.editor? 
        if @process.editable?(current_user) || @process.no_more_editable?(current_user)
          return
        else
          raise CanCan::AccessDenied.new
        end
      end

    end

    def milestoneable
      ::Legislation::Process.find(params[:process_id])
    end

    def milestoneable_path
      edition_legislation_process_milestones_path(milestoneable)
    end

    def resource
      @process || ::Legislation::Process.find(params[:process_id])
    end
end
