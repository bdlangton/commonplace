class AuthorsController < ApplicationController
  require 'will_paginate/array'

  # Create a new author.
  def new
    @author = Author.new
  end

  # List authors by user.
  def index
    @authors = current_user.authors

    # Sort.
    if params[:sort] == 'newest'
      @authors = @authors.sort_by(&:created_at).reverse
    else
      @authors = @authors.sort_by &:name
    end
  end

  # Show an author.
  def show
    @author = current_user.authors.find(params[:id])
    @tags = current_user.tags.by_author(params[:id]).order(:title)
    @sources = @author.sources

    unless @sources.empty?
      # @highlights = @sources.highlights.where(published: true)

      # if params[:favorite].present?
      #   @highlights = @highlights.where(favorite: true)
      # end
      # if params[:tag].present?
      #   @highlights = @highlights.tagged_with(params[:tag])
      # end
      # @highlights = @highlights.sort_by(&:location)
    end
  end

  # Edit an existing author.
  def edit
    @author = current_user.authors.find(params[:id])
  end

  # Update an existing author.
  def update
    @author = current_user.authors.find(params[:id])

    if @author.update(author_params)
      redirect_to @author
    else
      render 'edit'
    end
  end

  # Create a new author.
  def create
    @author = Author.new(author_params)

    if @author.save
      redirect_to @author
    else
      render 'new'
    end
  end

  # Delete a author.
  def destroy
    @author = current_user.authors.find(params[:id])
    @author.destroy

    redirect_to authors_path
  end

  private
    # Define which author fields are required and permitted.
    def author_params
      params.require(:author).permit(:name, :type, :user_id)
    end
end
