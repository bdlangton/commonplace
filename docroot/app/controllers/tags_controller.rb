class TagsController < ApplicationController
  autocomplete :tags, :title

  # Create a new tag.
  def new
    @tag = Tag.new
  end

  # List tags by user.
  def index
    @tags = current_user.tags.select('tags.*', 'count(*) as count')
      .left_joins(:taggings)
      .left_joins(:source_taggings)
      .left_joins(:author_taggings)
      .group("tags.id")
      .order("count(*) DESC")
  end

  # Show a tag.
  def show
    @tag = current_user.tags.find(params[:id])

    # Get highlights w/the tag.
    @highlights = @tag.highlights
    if params[:favorite].present?
      @highlights = @highlights.where(favorite: true)
    end
    @highlights = @highlights.by_user(current_user).where(published: true)

    # Get sources and authors w/the tag.
    @sources = @tag.sources.by_user(current_user)
    @authors = @tag.authors.by_user(current_user)
  end

  # Merge two tags into one.
  def merge
    @tags = current_user.tags
  end

  # Merge two tags into one (post action).
  def merge_post
    @tags = current_user.tags
    merged_tags = Array.new

    # Get form values.
    @tag_to_use = @tags.find_by_title(params[:tag_to_use])
    @tags_to_merge = @tags.where(title: params[:tags_to_merge])

    # Go through each tag to merge into the base tag.
    @tags_to_merge.each do |tag|
      merged_tags.push(tag.title)
      # Get every highlight that uses the old tag.
      @highlights = current_user.highlights.tagged_with(tag.title)
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
    @tag = current_user.tags.find(params[:id])
  end

  # Update a tag.
  def update
    @tag = current_user.tags.find(params[:id])

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
    @tag = current_user.tags.find(params[:id])
    @tag.destroy

    redirect_to tags_path
  end

  # Autocomplete tags for the user.
  def autocomplete_tags_title
    term = params[:term]

    # Get terms already entered to ensure we don't suggest terms already taken.
    existing_terms = params[:all_tags].split(',')
    existing_terms.pop
    existing_terms = existing_terms.map do |existing_term|
      existing_term.strip
    end

    if existing_terms.empty?
      tags = Tag.where('title LIKE ?', "#{term}%").order(:title).all | Tag.where('title LIKE ?', "%#{term}%").order(:title).all
    else
      tags = Tag.where('title LIKE ?', "#{term}%").where('title NOT IN (?)', Array.wrap(existing_terms)).order(:title).all | Tag.where('title LIKE ?', "%#{term}%").where('title NOT IN (?)', Array.wrap(existing_terms)).order(:title).all
    end

    render :json => tags.map { |tag| {:id => tag.id, :label => tag.title, :value => tag.title} }
  end

  private
    # Define which tag fields are required and permitted.
    def tag_params
      params.require(:tag).permit(:title, :user_id)
    end
end
