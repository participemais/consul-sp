class Admin::Poll::ElectoralCollegesController < Admin::Poll::BaseController
  load_and_authorize_resource class: "Poll::ElectoralCollege"
  load_and_authorize_resource :poll

  before_action :load_electoral_college, except: [:index, :new, :create]


  def index
    @electoral_college = @poll.electoral_college
    @electors = @electoral_college.electors.page(params[:page]).per(50) if @electoral_college
    respond_to do |format|
      format.html
      format.csv do
        send_data Poll::Electors::Exporter.new(
          @electoral_college.electors
        ).to_csv, filename: "#{@electoral_college.filename}.csv"
      end
    end
  end

  def new
    @electoral_college = Poll::ElectoralCollege.new
  end

  def create
    @electoral_college = Poll::ElectoralCollege.new(electoral_college_params)

    if @electoral_college.save
      redirect_to admin_poll_electoral_colleges_path(@poll)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @electoral_college.update(electoral_college_params)
      redirect_to admin_poll_electoral_colleges_path(@poll), notice: t("flash.actions.save_changes.notice")
    else
      render :edit
    end
  end

  def destroy
    if @electoral_college.destroy
      notice = "Question destroyed succesfully"
    else
      notice = t("flash.actions.destroy.error")
    end
    redirect_to admin_poll_electoral_colleges_path(@poll), notice: notice
  end

  private

    def electoral_college_params
      params.require(:poll_electoral_college).permit(:title, :poll_id)
    end

    def load_electoral_college
      @electoral_college = Poll::ElectoralCollege.find(params[:id])
    end
end
