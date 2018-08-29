class HighlightsController < ApplicationController
  def new
    @highlight = Highlight.new
    @tags = Tag.all
    @source = nil
    if params[:source]
      @source = params[:source]
    end
  end

  def index
    if params[:tag]
      @highlights = Highlight.tagged_with(params[:tag]).paginate(:page => params[:page], :per_page => 20)
    else
      @highlights = Highlight.paginate(:page => params[:page], :per_page => 20)
    end
  end

  def edit
    @highlight = Highlight.find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all
  end

  def update
    @highlight = Highlight.find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all

    if @highlight.update(highlight_params)
      redirect_to @highlight
    else
      render 'edit'
    end
  end

  def create
    @highlight = Highlight.new(highlight_params)

    if @highlight.save
      redirect_to @highlight
    else
      render 'new'
    end
  end

  def favorite
    @highlight = Highlight.find(params[:id])
    @highlight.favorite = true
    @highlight.save
    render json: @highlight
  end

  def unfavorite
    @highlight = Highlight.find(params[:id])
    @highlight.favorite = false
    @highlight.save
    render json: @highlight
  end

  def destroy
    @highlight = Highlight.find(params[:id])
    @highlight.destroy

    redirect_to highlights_path
  end

  private
    def highlight_params
      params.require(:highlight).permit(:highlight, :note, :location, :all_tags, :user_id, :source_id)
    end
end
