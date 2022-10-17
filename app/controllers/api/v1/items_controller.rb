class Api::V1::ItemsController < ApplicationController
  include ExceptionHandler
  def index
    render json: MerchantSerializer.new(Merchant.find(params[:id]).items)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end