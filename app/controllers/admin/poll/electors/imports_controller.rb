class Admin::Poll::Electors::ImportsController < Admin::Poll::BaseController
  load_and_authorize_resource class: "Poll::Electors::Import"
  load_and_authorize_resource :poll
  load_and_authorize_resource :electoral_college, class: "::Poll::ElectoralCollege"

  def create
    @import = Poll::Electors::Import.new(@electoral_college, electors_import_params)

    if @import.save
      flash.now[:notice] = t("admin.poll_electors.import.create.notice")
      render :show
    else
      render :new
    end
  end

  private

  def electors_import_params
    return {} unless params[:poll_electors_import]
    params.require(:poll_electors_import).permit(:file)
  end
end
