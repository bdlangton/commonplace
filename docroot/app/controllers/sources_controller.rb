# frozen_string_literal: true

# Sources controller.
class SourcesController < ApplicationController
  require "will_paginate/array"
  include SourcesControllerConcern

  # Create a new source.
  def new
    @source = Source.new
    if params[:author]
      @author = params[:author]
    end
  end

  # List sources by user.
  def index
    @sources = current_user.sources
    @source_types = @sources.select(:source_type).distinct.sort_by(&:source_type)
    if params[:source_type].present?
      @sources = @sources.where(source_type: params[:source_type])
    end

    # Sort.
    if params[:sort] == "title"
      @sources = @sources.sort_by(&:title)
    else
      @sources = @sources.sort_by(&:created_at).reverse
    end
  end

  # Show a source.
  def show
    @source = current_user.sources.find(params[:id])
    @tags = current_user.tags.by_source(params[:id]).order(:title)
    @highlights = @source.highlights.where(published: true)
    @highlights_count = @highlights.count
    @favorites_count = @highlights.where(favorite: true).count
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
    @author = authors_comma_separated(@source)
  end

  # Update an existing source.
  def update
    @source = current_user.sources.find(params[:id])
    @author = authors_comma_separated(@source)

    # Change all_authors to be an array containing the comma separated list of
    # authors and the current user ID. We need the user ID in order to save the
    # author to the correct user when creating a new author, since the author
    # doesn't already have the user_id saved.
    params = source_params.merge('all_authors': [
                                   source_params["all_authors"],
                                   source_params["user_id"],
                                 ])
    params = params.merge('all_tags': [
                            source_params["all_tags"],
                            source_params["user_id"],
                          ])

    if @source.update(params)
      redirect_to @source
    else
      render "edit"
    end
  end

  # Create a new source.
  def create
    # Change all_authors to be an array containing the comma separated list of
    # authors and the current user ID. We need the user ID in order to save the
    # author to the correct user when creating a new author, since the author
    # doesn't already have the user_id saved.
    params = source_params.merge('all_authors': [
                                   source_params["all_authors"],
                                   source_params["user_id"],
                                 ])
    params = params.merge('all_tags': [
                            source_params["all_tags"],
                            source_params["user_id"],
                          ])

    @source = Source.new(params)

    if @source.save
      redirect_to @source
    else
      render "new"
    end
  end

  # Delete a source.
  def destroy
    @source = current_user.sources.find(params[:id])
    @source.destroy

    redirect_to sources_path
  end

  # Autocomplete authors for the user.
  def autocomplete_authors_name
    term = params[:term]

    # Get terms already entered to ensure we don't suggest terms already taken.
    existing_authors = params[:all_authors].split(",")
    existing_authors.pop
    existing_authors = existing_authors.map do |existing_author|
      existing_author.strip
    end

    if existing_authors.empty?
      authors = current_user.authors.where("name LIKE ?", "#{term}%").order(:name).all | current_user.authors.where("name LIKE ?", "%#{term}%").order(:name).all
    else
      authors = current_user.authors.where("name LIKE ?", "#{term}%").where("name NOT IN (?)", Array.wrap(existing_authors)).order(:name).all | current_user.authors.where("name LIKE ?", "%#{term}%").where("name NOT IN (?)", Array.wrap(existing_authors)).order(:name).all
    end

    render json: authors.map { |author| { id: author.id, label: author.name, value: author.name } }
  end

  private
    # Define which source fields are required and permitted.
    def source_params
      params.require(:source).permit(:title, :all_authors, :all_tags, :source_type, :notes, :file, :file_cache, :remove_file, :user_id)
    end
end
