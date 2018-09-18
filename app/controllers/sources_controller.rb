class SourcesController < ApplicationController
  def new
    @source = Source.new
  end

  def index
    @sources = Source.all.by_user(current_user).sort_by &:title
  end

  def show
    @source = Source.find(params[:id])
  end

  def edit
    @source = Source.find(params[:id])
  end

  def update
    @source = Source.find(params[:id])

    if @source.update(source_params)
      redirect_to @source
    else
      render 'edit'
    end
  end

  def create
    @source = Source.new(source_params)

    if @source.save
      redirect_to @source
    else
      render 'new'
    end
  end

  def destroy
    @source = Source.find(params[:id])
    @source.destroy

    redirect_to sources_path
  end

  private
    def source_params
      params.require(:source).permit(:title, :author, :source_type, :user_id)
    end
end
