class Edition::Legislation::MilestonesController < Edition::MilestonesController
  include FeatureFlags
  feature_flag :legislation

  def index
    @process = milestoneable
  end

  private

    def milestoneable
      ::Legislation::Process.find(params[:process_id])
    end

    def milestoneable_path
      edition_legislation_process_milestones_path(milestoneable)
    end
end
