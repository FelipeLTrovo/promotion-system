require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
    
    test 'can create a promotion' do
        user = login_user
        post '/promotions', params: {
           promotion: {name: 'Natal', description: 'Promoção de Natal', 
                       code: 'NATAL10', discount_rate: 15, 
                       coupon_quantity: 5, expiration_date: '22/12/2033', user: user}
        }   
        assert_redirected_to promotion_path(Promotion.last)
        #assert_response :found
        follow_redirect!
        #assert_response :success
        assert_select 'h3', 'Natal'
    end

    test 'cannot create a promotion without login' do
        user = User.create!(email: "campuscode@iugu.com.br", name: "Campus Code", password: "123456")
        post '/promotions', params: {
           promotion: {name: 'Natal', description: 'Promoção de Natal', 
                       code: 'NATAL10', discount_rate: 15, 
                       coupon_quantity: 5, expiration_date: '22/12/2033', user: user}
        }   
        assert_redirected_to new_user_session_path
    end

    test 'cannot generate coupons without login' do
        user = User.create!(email: "campuscode@iugu.com.br", name: "Campus Code", password: "123456")
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)

        post generate_coupons_promotion_path(promotion)
        assert_redirected_to new_user_session_path
    end

    test 'cannot update a promotion without login' do
        user = User.create!(email: "campuscode@iugu.com.br", name: "Campus Code", password: "123456")
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        
        patch promotion_path(promotion), params: {
            promotion: {name: 'Black Friday', description: 'Promoção de Black Friday', code: 'BLACK10'}
        }

        assert_redirected_to new_user_session_path
    end

    test 'cannot delete a promotion without login' do
        user = User.create!(email: "campuscode@iugu.com.br", name: "Campus Code", password: "123456")
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        
        delete promotion_path(promotion)

        assert_redirected_to new_user_session_path
    end

    #TESTE DE LOGIN DA APROVAÇÃO

    test 'cannot approve if owner' do
        user = User.create!(email: "campuscode@iugu.com.br", name: "Campus Code", password: "123456")
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        
        login_user(user)
        
        post approve_promotion_path(promotion)

        assert_redirected_to promotion_path(promotion)
        refute promotion.reload.approved?
        assert_equal 'Ação não permitida', flash[:alert]
    end
end