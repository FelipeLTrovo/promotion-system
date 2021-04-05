class Api::V1::CouponsController < Api::V1::ApiController

    def show
        @coupon = Coupon.active.find_by!(code: params[:code])
        #render json: @coupon.as_json(methods: :discount_rate)
    end

    #TODO create, update, destroy - resgatar erros parameter_missing por ex.
end