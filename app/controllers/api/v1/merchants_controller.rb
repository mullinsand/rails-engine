class Api::V1::MerchantsController < ApplicationController
  def index
    # merchants = Merchant.all
    render json: MerchantSerializer.new(Merchant.all)
  end
end