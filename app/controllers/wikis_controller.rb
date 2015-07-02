class WikisController < ApplicationController
  def index
    @wikis = Wiki.visible_to(current_user).paginate(page: params[:page], per_page: 10)
    authorize @wikis
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end
  def create
    current_user.wikis.build(wiki_params)
    authorize @wiki
    if @wiki.save
      redirect_to @wiki, notice: "Topic was saved successfully."
    else
      flash[:error] = "Error creating topic. Please try again."
      render :new
    end
  end
  def update
    @wiki = Wiki.find(params[:id])
  end
  def destroy
    @wiki = Wiki.find(params[:id])
    authorize @wiki
    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error destroying the wiki"
      render :show
    end
  end
  private
    def wiki_params
      params.require.permit(:title,:body)
    end

end
