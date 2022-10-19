module ExceptionHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |error|
      render json: { errors: error.message }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |error|
      render json: { errors: error.message }, status: :unprocessable_entity
    end
  end

  def render_error(error, status)
    render json: { errors: error }, status: status
  end

  def negative_number_error
    render_error('Prices must be greater than or equal to zero', 400)
  end

  def name_and_price_error
    render_error('Name and price cannot be used on the same request', 400)
  end

  def empty_params_error
    render_error('No params listed in search', 400)
  end

  def min_greater_than_max
    render_error('Price minimum must be greater than maximum', 400)
  end

  def no_search_results
    render json: { data: { message: 'No results matched your search' } }, status: 200
  end
end