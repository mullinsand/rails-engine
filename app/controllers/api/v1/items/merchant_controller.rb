class Api::V1::Items::MerchantController < ApplicationController
  include ExceptionHandler
  def show
    item = Item.find(params[:item_id])
    merchant = item.merchant
    render json: MerchantSerializer.new(merchant)
  end
end