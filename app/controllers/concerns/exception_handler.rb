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
end