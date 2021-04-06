require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
    test 'disable a coupon' do
        user = login_user
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'BLABLABLA', promotion: promotion)
        visit promotion_path(promotion)
        click_on 'Desabilitar'

        assert_text "Cupom #{coupon.code} desabilitado com sucesso"
        assert_text "#{coupon.code} (desabilitado)"
        assert_no_text 'Desabilitar'
    end

    test 'enable a coupon' do
        user = login_user
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'BLABLABLA', status: :disabled, promotion: promotion)
        visit promotion_path(promotion)
        click_on 'Habilitar'

        assert_text "Cupom #{coupon.code} habilitado com sucesso"
        assert_text "#{coupon.code} (ativo)"
        assert_no_text 'Habilitar'
    end

    test 'search coupon by term and finds results' do
        user = login_user
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'BLABLABLA', status: :active, promotion: promotion)
        coupon_wrong = Coupon.create!(code: 'FULANO', status: :disabled, promotion: promotion)
        visit root_path
        click_on 'Promoções'
        fill_in 'Buscar cupom por código', with: 'BLABLABLA'
        click_on 'Buscar Cupom'
    
        assert_text coupon.code
        assert_equal coupon.status, 'active'
        assert_equal coupon.promotion.name, promotion.name
        assert_no_text coupon_wrong.code
    end

    test 'search coupon by term and finds nothing' do
        user = login_user
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'BLABLABLA', status: :active, promotion: promotion)
        coupon_wrong = Coupon.create!(code: 'FULANO', status: :disabled, promotion: promotion)
        visit root_path
        click_on 'Promoções'
        fill_in 'Buscar cupom por código', with: 'NOTHING'
        click_on 'Buscar Cupom'
    
        assert_no_text coupon.code
        assert_no_text coupon_wrong.code
        assert_text 'Cupom não encontrado.'
    end

    test 'do not search coupon by term using route without login' do
        visit search_coupons_path
        assert_no_link 'Buscar Cupom'
        assert_current_path new_user_session_path
    end

    test 'do not search coupon by params using route without login' do
        user = User.create!(email: "johndoe@hotmail.com", name: "John Doe", password: "123456")
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033', user: user)
        coupon = Coupon.create!(code: 'BLABLABLA', status: :active, promotion: promotion)
        coupon_wrong = Coupon.create!(code: 'FULANO', status: :disabled, promotion: promotion)
    
        visit search_coupons_path(CODE: 'NOTHING')
    
        assert_no_text coupon.code
        assert_no_text coupon_wrong.code
    
        assert_current_path new_user_session_path
    end
    
end