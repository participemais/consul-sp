class Edition::Legislation::ProposalsController < Edition::Legislation::BaseController
  has_orders %w[id title supports], only: :index

  load_and_authorize_resource :process, class: "Legislation::Process"
  load_and_authorize_resource :proposal, class: "Legislation::Proposal", through: :process

  before_action :load_categories, only: [:index ]

  def index
    @proposals = @proposals.send("sort_by_#{@current_order}").page(params[:page])
    @all_tags = @process.custom_list + @process.subprefecture_list + @process.district_list
  end

  def toggle_selection
    @proposal.toggle :selected
    @proposal.save!
  end

  private

    def load_categories
      @categories = Tag.where(kind: "category").order(:name)
      @subprefectures = Tag.where(kind: "subprefecture").order(:name)
      @districts = Tag.where(kind: "district").order(:name)
    end
end
