class Api::V1::MerchantsController < ApplicationController
  include ExceptionHandler
  def index
    render json: MerchantSerializer.new(::Merchant.all)
  end

  def show
    render json: MerchantSerializer.new(::Merchant.find(params[:id]))
  end
end