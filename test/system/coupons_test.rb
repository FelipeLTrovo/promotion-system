require 'application_system_test_case'

class CouponsTest < ApplicationSystemTestCase
    test 'disable a coupon' do
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033')
        coupon = Coupon.create!(code: 'BLABLABLA', promotion: promotion)
        login_user
        visit promotion_path(promotion)
        click_on 'Desabilitar'

        assert_text "Cupom #{coupon.code} desabilitado com sucesso"
        assert_text "#{coupon.code} (desabilitado)"
        assert_no_text 'Desabilitar'
    end

    test 'enable a coupon' do
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 3,
                expiration_date: '22/12/2033')
        coupon = Coupon.create!(code: 'BLABLABLA', status: :disabled, promotion: promotion)
        login_user
        visit promotion_path(promotion)
        click_on 'Habilitar'

        assert_text "Cupom #{coupon.code} habilitado com sucesso"
        assert_text "#{coupon.code} (ativo)"
        assert_no_text 'Habilitar'
    end
    
end