# frozen_string_literal: true

# Highlights controller.
class HighlightsController < ApplicationController
  include TagsControllerConcern
  require "will_paginate/array"

  def search
    if params["search"].present?
      search = params["search"]
      model = params["model"].blank? ? "All" : params["model"]
      @highlights = @sources = @authors = @tags = []

      if ["All", "Highlights"].include? model
        @highlights = current_user.highlights.where("highlight LIKE ? OR note LIKE ?", "%#{search}%", "%#{search}%").where(published: true)
      end

      if ["All", "Sources"].include? model
        @sources = current_user.sources.where("title LIKE ?", "%#{search}%")
      end

      if ["All", "Authors"].include? model
        @authors = current_user.authors.where("name LIKE ?", "%#{search}%")
      end

      if ["All", "Tags"].include? model
        @tags = tags_with_count
        @tags = @tags.where("title LIKE ?", "%#{search}%")
      end
    end
  end

  # Create new highlight.
  def new
    @highlight = Highlight.new
    @tags = Tag.all
    @source = nil
    session[:return_to] = request.referer
    if params[:source]
      @source = params[:source]
    end
  end

  # Show a list of highlights by the user.
  def index
    @authors = current_user.authors.order(:name)
    @highlights = current_user.highlights.where(published: true)

    if params[:favorite].present?
      @highlights = @highlights.where(favorite: true)
    end

    if params[:tag].present?
      @highlights = @highlights.tagged_with(params[:tag])
    end

    if params[:author].present?
      @highlights = @highlights.by_author(params[:author])
      @tags = current_user.tags.by_author(params[:author]).where(highlights: { published: true }).distinct.order(:title)
    else
      @tags = current_user.tags.joins(:highlights).where(highlights: { published: true }).distinct.order(:title)
    end

    @highlights = @highlights.sort_by(&:created_at).reverse
    @highlights = @highlights.paginate(page: params[:page], per_page: 20)
  end

  # Show favorite highlights by the user.
  def favorites
    @authors = current_user.authors.order(:name)
    @highlights = current_user.highlights.where(favorite: true, published: true)

    if params[:tag].present?
      @highlights = @highlights.tagged_with(params[:tag])
    end

    if params[:author].present?
      @highlights = @highlights.by_author(params[:author])
      @tags = current_user.tags.by_author(params[:author]).where(highlights: { favorite: true, published: true }).distinct.order(:title)
    else
      @tags = current_user.tags.joins(:highlights).where(highlights: { favorite: true, published: true }).distinct.order(:title)
    end

    @highlights = @highlights.paginate(page: params[:page], per_page: 20)
  end

  # Show a list of deleted (unpublished) highlights.
  def deleted
    @tags = current_user.tags.joins(:highlights).where(highlights: { published: false }).distinct.order(:title)
    @highlights = current_user.highlights.where(published: false)
    if params[:tag].present?
      @highlights = @highlights.tagged_with(params[:tag])
    end
    @highlights = @highlights.paginate(page: params[:page], per_page: 20)
  end

  # Edit an existing highlight.
  def edit
    @highlight = current_user.highlights.find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all
    session[:return_to] = request.referer
  end

  # Update an existing highlight.
  def update
    @highlight = current_user.highlights.find(params[:id])
    @source = @highlight.source_id
    @tags = Tag.all

    # Change all_tags to be an array containing the comma separated list of tags
    # and the current user ID. We need the user ID in order to save the tag to
    # the correct user when creating a new highlight, since the highlight
    # doesn't already have the user_id saved.
    params = highlight_params.merge('all_tags': [
      highlight_params["all_tags"],
      highlight_params["user_id"]
    ])

    if @highlight.update(params)
      redirect_to session[:return_to]
    else
      render "edit"
    end
  end

  # Create a new highlight.
  def create
    # Change all_tags to be an array containing the comma separated list of tags
    # and the current user ID. We need the user ID in order to save the tag to
    # the correct user when creating a new highlight, since the highlight
    # doesn't already have the user_id saved.
    params = highlight_params.merge('all_tags': [
      highlight_params["all_tags"],
      highlight_params["user_id"]
    ])

    @highlight = Highlight.new(params)

    if @highlight.save
      redirect_to session[:return_to]
    else
      render "new"
    end
  end

  # Favorite a highlight. Ajax callback.
  def favorite
    @highlight = current_user.highlights.find(params[:id])
    @highlight.favorite = true
    @highlight.save
    render json: @highlight
  end

  # Unfavorite a highlight. Ajax callback.
  def unfavorite
    @highlight = current_user.highlights.find(params[:id])
    @highlight.favorite = false
    @highlight.save
    render json: @highlight
  end

  # Publish a highlight with ajax call.
  def publish
    @highlight = current_user.highlights.find(params[:id])
    @highlight.published = true
    @highlight.save
    render json: @highlight
  end

  # Unpublish a highlight with ajax call.
  def unpublish
    @highlight = current_user.highlights.find(params[:id])
    @highlight.published = false
    @highlight.save
    render json: @highlight
  end

  # Unpublish a highlight (not actually delete).
  def destroy
    @highlight = current_user.highlights.find(params[:id])
    @highlight.published = false
    @highlight.save

    redirect_to highlights_path
  end

  private
    # Define which highlight fields are required and permitted.
    def highlight_params
      params.require(:highlight).permit(:highlight, :note, :all_tags, :favorite, :published, :user_id, :source_id)
    end
end
