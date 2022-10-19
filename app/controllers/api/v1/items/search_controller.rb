class Api::V1::Items::SearchController < ApplicationController
  include ExceptionHandler
  def find
    if params[:name] && (params[:min_price] || params[:max_price])
      name_and_price_error
    elsif params_present?(params[:name])
      item = Item.find_by_name(params[:name])
      item ? (render json: ItemSerializer.new(item)) : no_search_results
    elsif params_present?(params[:min_price], params[:max_price])
      return negative_number_error if Item.negative_prices?(params[:min_price], params[:max_price])
      return min_greater_than_max if min_greater_than_max?(params[:min_price], params[:max_price])

      item = Item.find_by_price(params[:min_price], params[:max_price])
      item ? (render json: ItemSerializer.new(item)) : no_search_results
    else
      empty_params_error
    end
  end

  def find_all
    if params[:name] && (params[:min_price] || params[:max_price])
      name_and_price_error
    elsif params_present?(params[:name])
      item = Item.find_by_name(params[:name], 'all')
      render json: ItemSerializer.new(item)
    elsif params_present?(params[:min_price], params[:max_price])
      return negative_number_error if Item.negative_prices?(params[:min_price], params[:max_price])
      return min_greater_than_max if min_greater_than_max?(params[:min_price], params[:max_price])

      item = Item.find_by_price(params[:min_price], params[:max_price], 'all')
      render json: ItemSerializer.new(item)
    else
      empty_params_error
    end
  end

  private

  def params_present?(param1, param2=nil)
    ![nil, ""].include?(param1) || ![nil, ""].include?(param2)
  end

  def min_greater_than_max?(min, max)
    return false if min.nil? || max.nil?
    
    min.to_i > max.to_i
  end
end