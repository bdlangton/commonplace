require '/usr/local/lib/ruby/gems/2.5.0/gems/kindle-highlights-2.0.1/lib/kindle_highlights.rb'

class HighlightsController < ApplicationController
  def new
    @highlight = Highlight.new
    @tags = Tag.all
  end

  def index
    @highlights = Highlight.all
  end

  def show
    @highlight = Highlight.find(params[:id])
  end

  def edit
    @highlight = Highlight.find(params[:id])
    @tags = Tag.all
  end

  def update
    @highlight = Highlight.find(params[:id])
    @tags = Tag.all

    params[:highlight][:tags].each do |k,v|
      @highlight.tags << Tag.find(k) if v.to_i > 0
    end

    if @highlight.update(highlight_params)
      redirect_to @highlight
    else
      render 'edit'
    end
  end

  def create
    @highlight = Highlight.new(highlight_params)

    params[:highlight][:tags].each do |k,v|
      @highlight.tags << Tag.find(k) if v.to_i > 0
    end

    if @highlight.save
      redirect_to @highlight
    else
      render 'new'
    end
  end

  def destroy
    @highlight = Highlight.find(params[:id])
    @highlight.destroy

    redirect_to highlights_path
  end

  private
    def highlight_params
      params.require(:highlight).permit(:highlight, :note, :location, :user_id, :source_id)
    end
end
