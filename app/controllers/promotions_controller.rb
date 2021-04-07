class PromotionsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_promotion, only: %i[show edit update destroy generate_coupons approve]
    before_action :can_be_approved, only: %i[approve]

    def index
        @promotions = Promotion.all
    end

    def show
        
    end

    def new
        @promotion = Promotion.new
    end

    def create
        @promotion = current_user.promotions.new(promotion_params)
        if @promotion.save
            redirect_to @promotion
        else
            render :new
        end
    end

    def edit
    end

    def update
        if @promotion.update(promotion_params)
            redirect_to @promotion, notice: t('.success')
        else
          render :edit
        end
    end

    def destroy
        if @promotion.destroy
            redirect_to @promotion, notice: t('.success')
        end
    end

    def generate_coupons
        @promotion.generate_coupons!
        redirect_to @promotion, notice: t('.success')
    end

    def search
        @promotions = Promotion.search(params[:q])
        render :index
    end

    def approve
        current_user.promotion_approvals.create!(promotion: @promotion)
        PromotionMailer.with(promotion: @promotion, approver: current_user).approval_email.deliver_now
        byebug
        redirect_to @promotion, notice: "Promoção aprovada com sucesso"
    end
    
    private
        def set_promotion
            @promotion = Promotion.find(params[:id])
        end

        def promotion_params
            params
            .require(:promotion)
            .permit(:name, :expiration_date, :description,
                    :discount_rate, :code, :coupon_quantity)
        end

        def can_be_approved
            redirect_to @promotion, alert: 'Ação não permitida' unless @promotion.can_approve?(current_user)
        end
    
end