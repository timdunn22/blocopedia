class WikisController < ApplicationController
  def index
    @wikis = policy_scope(Wiki)

  end

  def edit
    @wiki = Wiki.find(params[:id])
    @wiki.collaborators.build
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
    @wiki = current_user.wikis.build(wiki_params)
    #authorize @wiki
    if @wiki.save
      redirect_to @wiki, notice: "Wiki was saved successfully."
    else
      flash[:error] = "Error creating wiki. Please try again."
      render :new
    end
  end
  def update
    @wiki = Wiki.find(params[:id])

    params[:wiki][:collaborators_attributes].values.each do |collaborator_params|

      if collaborator_params[:active] == "1"

        @wiki.collaborators.where(user_id: collaborator_params[:user_id]).first_or_create!
      elsif @wiki.collaborators.exists?(user_id: collaborator_params[:user_id])
        @wiki.collaborators.find_by_user_id(collaborator_params[:user_id]).destroy!
      end
    end
    # for each user that is checked create a new collaborator that is associated with the current wiki
    # and destroy all collaborators that are not checked from the current wiki
    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki was updated"
      redirect_to wiki_path
    else
      flash[:error] = "Invalid Wiki information"
      render :edit
    end
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
      params.require(:wiki).permit(:title,:body,:private)
    end

end
