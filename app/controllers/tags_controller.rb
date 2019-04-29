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
    @highlights = @tag.highlights
    if params[:favorite].present?
      @highlights = @highlights.where(favorite: true)
    end
    @highlights = @highlights.by_user(current_user).where(published: true)
  end

  # Merge two tags into one.
  def merge
    @tags = Tag.by_user(current_user)
  end

  # Merge two tags into one (post action).
  def merge_post
    @tags = Tag.by_user(current_user)
    merged_tags = Array.new

    # Get form values.
    @tag_to_use = @tags.find_by_title(params[:tag_to_use])
    @tags_to_merge = @tags.where(title: params[:tags_to_merge])

    # Go through each tag to merge into the base tag.
    @tags_to_merge.each do |tag|
      merged_tags.push(tag.title)
      # Get every highlight that uses the old tag.
      @highlights = Highlight.by_user(current_user).tagged_with(tag.title)
      @highlights.each do |highlight|
        highlight.tags = highlight.tags.map do |highlight_tag|
          # If the tag matches the old tag, return the tag to use instead.
          if highlight_tag.id == tag.id
            @tag_to_use
          else
            highlight_tag
          end
        end
        highlight.save
      end
      tag.destroy
    end
    flash[:notice] = "#{merged_tags.join(', ')} merged into #{@tag_to_use.title}."
    redirect_to tags_merge_path
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
