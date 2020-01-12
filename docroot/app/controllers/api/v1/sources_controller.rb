# frozen_string_literal: true

class Api::V1::SourcesController < ApplicationController
  require "will_paginate/array"

  def index
    @sources = current_user.sources
    render json: @sources
  end

  def create
    source = Source.create(source_params)
    render json: source
  end

  def destroy
    Source.destroy(params[:id])
  end

  def update
    source = Source.find(params[:id])
    source.update_attributes(source_params)
    render json: source
  end

  private
    # Define which source fields are required and permitted.
    def source_params
      params.require(:source).permit(:title, :all_authors, :all_tags, :source_type, :notes, :user_id)
    end
end
