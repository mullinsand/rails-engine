class Api::V1::ItemsController < ApplicationController
  include ExceptionHandler
  def index
    render json: ItemSerializer.new(::Item.all)
  end

  def show
    render json: ItemSerializer.new(::Item.find(params[:id]))
  end

  def create
    render json: ItemSerializer.new(::Item.create(item_params)), status: 201
  end

  def update
    render json: ItemSerializer.new(::Item.update(params[:id], item_params))
  end

  def destroy
    ::Item.find(params[:id])
    render json: ::Item.delete(params[:id])
  end

  def find
    if params[:name] && (params[:min_price] || params[:max_price])
      #error
    elsif params[:name]
      item = Item.find_by_name(params[:name])
      render api_v1_item_path(item)
    elsif params[:min_price] && params[:max_price]
    
    elsif params[:min_price]

    elsif params[:max_price]
    
    end
  end
  private

  def item_params
    ::Merchant.find(params[:merchant_id]) if params[:merchant_id]
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end