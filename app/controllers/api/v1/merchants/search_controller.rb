class Api::V1::Merchants::SearchController < ApplicationController
  include ExceptionHandler
  def find_all
    if params_present?(params[:name])
      merchants = Merchant.find_by_name(params[:name], 'all')
      render json: MerchantSerializer.new(merchants)
    else
      empty_params_error
    end
  end

  def find
    if params_present?(params[:name])
      merchant = Merchant.find_by_name(params[:name])
      merchant ? (render json: MerchantSerializer.new(merchant)) : no_search_results
    else
      empty_params_error
    end
  end

  private

  def params_present?(param)
    ![nil, ''].include?(param)
  end
end