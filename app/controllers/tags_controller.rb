class TagsController < ApplicationController
  # Create a new tag.
  def new
    @tag = Tag.new
  end

  # List tags by user.
  def index
    @tags = Tag.by_user(current_user).select('tags.*', 'count(*) as count')
      .left_joins(:taggings)
      .group("tags.id")
      .order("count(taggings.highlight_id) DESC")
  end

  # Show a tag.
  def show
    @tag = Tag.by_user(current_user).find(params[:id])
    @highlights = @tag.highlights.where(published: true)
  end

  # Edit a tag.
  def edit
    @tag = Tag.by_user(current_user).find(params[:id])
  end

  # Update a tag.
  def update
    @tag = Tag.by_user(current_user).find(params[:id])

    if @tag.update(tag_params)
      redirect_to @tag
    else
      render 'edit'
    end
  end

  # Create a new tag.
  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to @tag
    else
      render 'new'
    end
  end

  # Delete a tag.
  def destroy
    @tag = Tag.by_user(current_user).find(params[:id])
    @tag.destroy

    redirect_to tags_path
  end

  private
    # Define which tag fields are required and permitted.
    def tag_params
      params.require(:tag).permit(:title, :user_id)
    end
end
