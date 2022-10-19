module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: { errors: error.message }, status: :not_found
    end

    # rescue_from ActiveRecord::RecordInvalid do |error|
    #   render json: { errors: error.message }, status: :unprocessable_entity
    # end

  end

  def negative_number_error
    render json: { errors: 'Prices must be greater than or equal to zero' }, status: 400
  end

  def name_and_price_error
    render json: { errors: 'Name and price cannot be used on the same request' }, status: 400
  end

  def empty_params_error
    render json: { errors: 'No params listed in search' }, status: 400
  end

  def no_search_results
    render json: { data: { message: 'No results matched your search'}}, status: 200
  end
end