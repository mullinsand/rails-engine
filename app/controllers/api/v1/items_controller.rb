class Api::V1::ItemsController < ApplicationController
  include ExceptionHandler
  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end
end