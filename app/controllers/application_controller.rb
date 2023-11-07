class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :invalid_response
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_response

  def invalid_response(exception)
    render json: ErrorSerializer.new(exception).bad_request, status: 404
  end
end
