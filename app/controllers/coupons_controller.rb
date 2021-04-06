class CouponsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_promotion, only: %i[show]

    
    def show
    end
    
    def disable
        @coupon = Coupon.find(params[:id])
        @coupon.disabled!
        redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
    end
    
    def enable
        @coupon = Coupon.find(params[:id])
        @coupon.active!
        redirect_to @coupon.promotion, notice: t('.success', code: @coupon.code)
    end
    
    def search
        @coupon = Coupon.find_by!(code: params[:code])
        render :show
    rescue
        redirect_to promotions_path, notice: "Cupom não encontrado."
    end

    private
        def set_coupon
            @coupon = Coupon.find(params[:id])
        end

end