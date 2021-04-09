class Api::V1::ApiController < ActionController::API
    respond_to :json
    rescue_from ActiveRecord::RecordNotFound, with: :not_found_error
    rescue_from ActionController::ParameterMissing, with: :parameter_missing_error
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_error
    
    
    private

        def not_found_error
            head 404
        end

        def parameter_missing_error
            head 400
        end

        def unprocessable_entity_error
            head 422
        end
end