class SourcesController < ApplicationController
  require 'will_paginate/array'

  # Create a new source.
  def new
    @source = Source.new
  end

  # List sources by user.
  def index
    @sources = current_user.sources
    @source_types = @sources.select(:source_type).distinct.sort_by &:source_type
    if params[:source_type].present?
      @sources = @sources.where(source_type: params[:source_type])
    end

    # Sort.
    if params[:sort] == 'newest'
      @sources = @sources.sort_by(&:created_at).reverse
    else
      @sources = @sources.sort_by &:title
    end
  end

  # Show a source.
  def show
    @source = current_user.sources.find(params[:id])
    @tags = current_user.tags.by_source(params[:id]).order(:title)
    @highlights = @source.highlights.where(published: true)
    if params[:favorite].present?
      @highlights = @highlights.where(favorite: true)
    end
    if params[:tag].present?
      @highlights = @highlights.tagged_with(params[:tag])
    end
    @highlights = @highlights.sort_by(&:location)
  end

  # Edit an existing source.
  def edit
    @source = current_user.sources.find(params[:id])
  end

  # Update an existing source.
  def update
    @source = current_user.sources.find(params[:id])

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
    @source = current_user.sources.find(params[:id])
    @source.destroy

    redirect_to sources_path
  end

  private
    # Define which source fields are required and permitted.
    def source_params
      params.require(:source).permit(:title, :author, :source_type, :notes, :user_id)
    end
end
