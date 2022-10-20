class Api::V1::MerchantsController < ApplicationController
  include ExceptionHandler
  include Pagination
  
  def index
    paginated_results = paginate(Merchant.all, params[:per_page], params[:page])
    render json: MerchantSerializer.new(paginated_results)
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id]))
  end
end