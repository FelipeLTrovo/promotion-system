class Api::V1::ProductCategoriesController < Api::V1::ApiController
    before_action :set_product_category, only: %i[show update destroy]

    def show
    end

    def create
        @product_category = ProductCategory.create!(product_category_params)
        render :show
    end

    def update
        @product_category.update!(product_category_params)
        render :show
    end

    def destroy
        @product_category.destroy!
    end

    private

        def product_category_params
            params.require(:product_category).permit(:name, :code)
        end

        def set_product_category
            @product_category = ProductCategory.find_by!(code: params[:code])
        end

end