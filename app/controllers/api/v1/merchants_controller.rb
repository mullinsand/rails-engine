class Api::V1::MerchantsController < ApplicationController
  include ExceptionHandler
  def index
    render json: MerchantSerializer.new(::Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(::Merchant.find(params[:id]))
  end

  def find_all
    if params_present?(params[:name])
      merchants = ::Merchant.find_by_name(params[:name], 'all')
      render json: MerchantSerializer.new(merchants)
    else
      empty_params_error
    end
  end

  private

  def params_present?(param)
    ![nil, ''].include?(param)
  end
end