class Api::V1::Item::MerchantController < ApplicationController
  include ExceptionHandler
  def show
    item = ::Item.find(params[:item_id])
    render json: MerchantSerializer.new(::Merchant.find(item.merchant_id))
  end
end