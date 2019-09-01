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
    @sources = @author.sources
  end

  # Edit an existing author.
  def edit
    @author = current_user.authors.find(params[:id])
  end

  # Update an existing author.
  def update
    @author = current_user.authors.find(params[:id])

    # Change all_tags to be an array containing the comma separated list of tags
    # and the current user ID. We need the user ID in order to save the tag to
    # the correct user when creating a new highlight, since the highlight
    # doesn't already have the user_id saved.
    params = author_params.merge('all_tags': [
      author_params['all_tags'],
      author_params['user_id']
    ])

    if @author.update(params)
      redirect_to @author
    else
      render 'edit'
    end
  end

  # Create a new author.
  def create
    # Change all_tags to be an array containing the comma separated list of tags
    # and the current user ID. We need the user ID in order to save the tag to
    # the correct user when creating a new highlight, since the highlight
    # doesn't already have the user_id saved.
    params = author_params.merge('all_tags': [
      author_params['all_tags'],
      author_params['user_id']
    ])

    @author = Author.new(params)

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
      params.require(:author).permit(:name, :type, :all_tags, :user_id)
    end
end
