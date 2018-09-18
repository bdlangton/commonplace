class TagsController < ApplicationController
  def new
    @tag = Tag.new
  end

  def index
    @tags = Tag.by_user(current_user).select('tags.*', 'count(*) as count')
      .left_joins(:taggings)
      .group("tags.id")
      .order("count(taggings.highlight_id) DESC")
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def edit
    @tag = Tag.find(params[:id])
  end

  def update
    @tag = Tag.find(params[:id])

    if @tag.update(tag_params)
      redirect_to @tag
    else
      render 'edit'
    end
  end

  def create
    @tag = Tag.new(tag_params)

    if @tag.save
      redirect_to @tag
    else
      render 'new'
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    redirect_to tags_path
  end

  private
    def tag_params
      params.require(:tag).permit(:title, :user_id)
    end
end
