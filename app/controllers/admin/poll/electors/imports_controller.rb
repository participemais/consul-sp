class Admin::Poll::Electors::ImportsController < Admin::Poll::BaseController
  load_and_authorize_resource class: "Poll::Elector::Import"
  load_and_authorize_resource :poll
  load_and_authorize_resource :electoral_college, class: "::Poll::ElectoralCollege"

  def create
    @import = Poll::Elector::Import.new(@electoral_college, electors_import_params)

    if @import.save
      flash.now[:notice] = t("admin.polls.electors.imports.create.notice")
      render :show
    else
      render :new
    end
  end

  private

  def electors_import_params
    params.require(:poll_elector_import).permit(:file)
  end
end
