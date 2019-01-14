class SourcesController < ApplicationController
  # Create a new source.
  def new
    @source = Source.new
  end

  # List sources by user.
  def index
    @sources = Source.all.by_user(current_user).sort_by &:title
  end

  # Show a source.
  def show
    @source = Source.by_user(current_user).find(params[:id])
    @highlights = @source.highlights.where(published: true).sort_by(&:location)
  end

  # Edit an existing source.
  def edit
    @source = Source.by_user(current_user).find(params[:id])
  end

  # Update an existing source.
  def update
    @source = Source.by_user(current_user).find(params[:id])

    if @source.update(source_params)
      redirect_to @source
    else
      render 'edit'
    end
  end

  # Create a new source.
  def create
    @source = Source.new(source_params)

    if @source.save
      redirect_to @source
    else
      render 'new'
    end
  end

  # Delete a source.
  def destroy
    @source = Source.by_user(current_user).find(params[:id])
    @source.destroy

    redirect_to sources_path
  end

  private
    # Define which source fields are required and permitted.
    def source_params
      params.require(:source).permit(:title, :author, :source_type, :user_id)
    end
end
