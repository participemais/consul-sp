class Admin::TagsController < Admin::BaseController
  before_action :find_tag, only: [:edit, :update, :destroy]

  respond_to :html, :js

  KINDS = { "category" => "Tema",  "subprefecture" => "Subprefeitura", "district" => "Distrito" }.freeze

  def index
    @category_tags = Tag.where(kind: "category").page(params[:page]).order(:name)
    @subprefecture_tags = Tag.where(kind: "subprefecture").page(params[:page]).order(:name)
    @district_tags = Tag.where(kind: "district").page(params[:page]).order(:name)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.create(name: tag_params["name"], kind: KINDS.key(tag_params["kind"]))

    if @tag.save
      redirect_to admin_tags_path, notice: t("admin.tags.create.notice")
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(name: tag_params["name"], kind: KINDS.key(tag_params["kind"]))
      redirect_to admin_tags_path, notice: t("flash.actions.save_changes.notice")
    else
      render :edit
    end
  end

  def destroy
    @tag.destroy!
    redirect_to admin_tags_path
  end

  private

    def tag_params
      params.require(:tag).permit(:name, :kind)
    end

    def find_tag
      @tag = Tag.find(params[:id])
    end
end
