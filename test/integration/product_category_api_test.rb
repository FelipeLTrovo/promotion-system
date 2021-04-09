require 'test_helper'

class ProductCategoryApiTest < ActionDispatch::IntegrationTest

    test 'show product category' do 
        product_category = Fabricate(:product_category)

        get "/api/v1/product_categories/#{product_category.code}", as: :json
        assert_response :success
        body = JSON.parse(response.body, symbolize_names: true)
        assert_equal product_category.name, body[:name]
        assert_equal product_category.code, body[:code]
    end

    test 'product category not found' do
        get "/api/v1/product_categories/NOTHING", as: :json
        assert_response :not_found
    end

    test 'route invalid without json header' do
        assert_raises ActionController::RoutingError do
            get '/api/v1/product_categories/0'
        end
    end

    test 'create product category' do
        assert_difference 'ProductCategory.count'  do
            post '/api/v1/product_categories', params: { name: 'Produto Legal', code: 'LEGAL'}, as: :json
        end
        assert_response :success
        body = JSON.parse(response.body, symbolize_names: true)
        assert_equal 'Produto Legal', body[:name]
        assert_equal 'LEGAL', body[:code]
    end

    test 'create product category without parameters' do
        post '/api/v1/product_categories/',  as: :json
        assert_response :bad_request
    end

    test 'create product category with invalid parameters' do
        product_category = Fabricate(:product_category, name: 'Produto Legal', code: 'LEGAL')
        post '/api/v1/product_categories/', params: { name: 'Produto Legal', code: 'LEGAL'}, as: :json
        assert_response :unprocessable_entity
    end

    test 'update product category' do 
        product_category = Fabricate(:product_category)
        patch "/api/v1/product_categories/#{product_category.code}", params: { name: 'Produto Legal', code: 'LEGAL'}, as: :json
        assert_response :success
        body = JSON.parse(response.body, symbolize_names: true)
        assert_equal 'Produto Legal', body[:name]
        assert_equal 'LEGAL', body[:code]
    end

    test 'update product category without parameters' do
        product_category = Fabricate(:product_category)
        patch "/api/v1/product_categories/#{product_category.code}",  as: :json
        assert_response :bad_request
    end

    test 'update product category with invalid parameters' do 
        product_category = Fabricate(:product_category)
        support_product_category = Fabricate(:product_category, name: 'Produto Legal', code: 'LEGAL')
        patch "/api/v1/product_categories/#{product_category.code}", params: { name: 'Produto Legal', code: 'LEGAL'}, as: :json
        assert_response :unprocessable_entity
    end

    test 'destroy product category' do
        product_category = Fabricate(:product_category)
        assert_difference 'ProductCategory.count', -1  do
            delete "/api/v1/product_categories/#{product_category.code}", as: :json
        end
        assert_response :success
    end

    test 'destroy product category not found' do
        delete '/api/v1/product_categories/0', as: :json
        assert_response :not_found
    end

end