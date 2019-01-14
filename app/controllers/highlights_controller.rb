class HighlightsController < ApplicationController
  autocomplete :tags, :title

  def new
    @highlight = Highlight.new
    @tags = Tag.all
    @source = nil
    session[:return_to] = request.referer
    if params[:source]
      @source = params[:source]
    end
  end

  def index
    if params[:tag]
      @highlights = Highlight.tagged_with(params[:tag]).by_user(current_user).where(published: true).paginate(:page => params[:page], :per_page => 20)
    else
      @highlights = Highlight.by_user(current_user).where(published: true).paginate(:page => params[:page], :per_page => 20)
    end
  end

  def favorites
    if params[:tag]
      @highlights = Highlight.tagged_with(params[:tag]).by_user(current_user).where(favorite: true, published: true).paginate(:page => params[:page], :per_page => 20)
    else
      @highlights = Highlight.by_user(current_user).where(favorite: true, published: true).paginate(:page => params[:page], :per_page => 20)
    end
  end

  # Show a list of deleted (unpublished) highlights.
  def deleted
    if params[:tag]
      @highlights = Highlight.tagged_with(params[:tag]).by_user(current_user).where(published: false).paginate(:page => params[:page], :per_page => 20)
    else
      @highlights = Highlight.by_user(current_user).where(published: false).paginate(:page => params[:page], :per_page => 20)
    end
  end

  def edit
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all
    session[:return_to] = request.referer
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

  # Publish a highlight with ajax call.
  def publish
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @highlight.published = true
    @highlight.save
    render json: @highlight
  end

  # Unpublish a highlight with ajax call.
  def unpublish
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @highlight.published = false
    @highlight.save
    render json: @highlight
  end

  def destroy
    @highlight = Highlight.by_user(current_user).find(params[:id])
    @highlight.published = false
    @highlight.save

    redirect_to highlights_path
  end

  # Autocomplete tags for the user.
  def autocomplete_tags_title
    term = params[:term]
    tags = Tag.where('title LIKE ?', "%#{term}%").order(:title).all
    render :json => tags.map { |tag| {:id => tag.id, :label => tag.title, :value => tag.title} }
  end

  private
    def highlight_params
      params.require(:highlight).permit(:highlight, :note, :location, :all_tags, :favorite, :published, :user_id, :source_id)
    end
end
