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
      name_and_price_error
    elsif params_present?(params[:name])
      item = ::Item.find_by_name(params[:name])
      item ? (render json: ItemSerializer.new(item)) : no_search_results
    elsif params_present?(params[:min_price], params[:max_price])
      if ::Item.negative_prices?(params[:min_price], params[:max_price])
        negative_number_error
      else
        item = ::Item.find_by_price(params[:min_price], params[:max_price])
        item ? (render json: ItemSerializer.new(item)) : no_search_results
      end
    else
      empty_params_error
    end
  end

  private

  def params_present?(param1, param2=nil)
    ![nil, ""].include?(param1) || ![nil, ""].include?(param2)
  end

  def item_params
    ::Merchant.find(params[:merchant_id]) if params[:merchant_id]
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end