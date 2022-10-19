class Api::V1::ItemsController < ApplicationController
  include ExceptionHandler

  def index
    render json: ItemSerializer.new(Item.all)
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(Item.create!(item_params)), status: 201
  end

  def update
    render json: ItemSerializer.new(Item.update(params[:id], item_params))
  end

  def destroy
    Item.find(params[:id])
    render json: Item.destroy(params[:id])
  end

  private

  def item_params
    Merchant.find(params[:merchant_id]) if params[:merchant_id]
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end