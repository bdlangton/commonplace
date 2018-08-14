require '/usr/local/lib/ruby/gems/2.5.0/gems/kindle-highlights-2.0.1/lib/kindle_highlights.rb'

class HighlightsController < ApplicationController
  def new
    @highlight = Highlight.new
  end

  def index
    @highlights = Highlight.all
  end

  def show
    @highlight = Highlight.find(params[:id])
  end

  def edit
    @highlight = Highlight.find(params[:id])
  end

  def update
    @highlight = Highlight.find(params[:id])

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

  def destroy
    @highlight = Highlight.find(params[:id])
    @highlight.destroy

    redirect_to highlights_path
  end

  private
    def highlight_params
      # params.require(:highlight).permit(:highlight)
    end
end
