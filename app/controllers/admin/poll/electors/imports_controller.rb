class Admin::Poll::Electors::ImportsController < Admin::Poll::BaseController
  load_and_authorize_resource class: "Poll::Elector::Import"
  load_and_authorize_resource :poll
  load_and_authorize_resource :electoral_college, class: "::Poll::ElectoralCollege"

  def create
    @import = Poll::Elector::Import.new(electors_import_params)

    if @import.save
      redirect_to admin_poll_electoral_colleges_path(@poll), notice: t("admin.polls.electors.imports.create.notice")
    else
      render :new
    end
  end

  private

  def electors_import_params
    params.require(:poll_elector_import).permit(:file)
  end
end
