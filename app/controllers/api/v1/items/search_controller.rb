class Api::V1::Items::SearchController < ApplicationController
  include ExceptionHandler
  include ParamsSieve
  before_action :name_and_price

  def find
    if params_present?(params[:name])
      item = Item.find_by_name(params[:name])
      item ? (render json: ItemSerializer.new(item)) : no_search_results
    elsif params_present?(params[:min_price], params[:max_price])
      return negative_number_error if negative_prices?
      return min_greater_than_max if min_greater_than_max?

      item = Item.find_by_price(params[:min_price], params[:max_price])
      item ? (render json: ItemSerializer.new(item)) : no_search_results
    else
      empty_params_error
    end
  end

  def find_all
    if params_present?(params[:name])
      item = Item.find_by_name(params[:name], 'all')
      render json: ItemSerializer.new(item)
    elsif params_present?(params[:min_price], params[:max_price])
      return negative_number_error if negative_prices?
      return min_greater_than_max if min_greater_than_max?

      item = Item.find_by_price(params[:min_price], params[:max_price], 'all')
      render json: ItemSerializer.new(item)
    else
      empty_params_error
    end
  end
end
