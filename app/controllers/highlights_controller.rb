class HighlightsController < ApplicationController
  def new
    @highlight = Highlight.new
    @tags = Tag.all
    @source = nil
    session[:return_to] ||= request.referer
    if params[:source]
      @source = params[:source]
    end
  end

  def index
    if params[:tag]
      @highlights = Highlight.tagged_with(params[:tag]).by_user(current_user).paginate(:page => params[:page], :per_page => 20)
    else
      @highlights = Highlight.by_user(current_user).paginate(:page => params[:page], :per_page => 20)
    end
  end

  def favorites
    if params[:tag]
      @highlights = Highlight.tagged_with(params[:tag]).by_user(current_user).where('favorite = true').paginate(:page => params[:page], :per_page => 20)
    else
      @highlights = Highlight.by_user(current_user).where('favorite = true').paginate(:page => params[:page], :per_page => 20)
    end
  end

  def edit
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all
    session[:return_to] ||= request.referer
  end

  def update
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all

    if @highlight.update(highlight_params)
      redirect_to session[:return_to]
    else
      render 'edit'
    end
  end

  def create
    @highlight = Highlight.new(highlight_params)

    if @highlight.save
      redirect_to session[:return_to]
    else
      render 'new'
    end
  end

  def favorite
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @highlight.favorite = true
    @highlight.save
    render json: @highlight
  end

  def unfavorite
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @highlight.favorite = false
    @highlight.save
    render json: @highlight
  end

  def destroy
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @highlight.destroy

    redirect_to highlights_path
  end

  private
    def highlight_params
      params.require(:highlight).permit(:highlight, :note, :location, :all_tags, :user_id, :source_id)
    end
end
