class HighlightsController < ApplicationController
  def new
  end

  def index
    @highlights = Highlight.all
  end

  def show
    @highlight = Highlight.find(params[:id])
  end

  def create
    @highlight = Highlight.new(highlight_params)

    @highlight.save
    redirect_to @highlight
  end

  private
    def highlight_params
      params.require(:highlight).permit(:title, :text)
    end
end
