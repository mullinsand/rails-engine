class Api::V1::Merchant::ItemsController < ApplicationController
  include ExceptionHandler
  def index
    Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(Item.where(merchant_id: params[:merchant_id]))
  end
end