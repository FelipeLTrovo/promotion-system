require "test_helper"

class PromotionTest < ActiveSupport::TestCase
  test 'attributes cannot be blank' do
    promotion = Promotion.new

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'não pode ficar em branco'
    assert_includes promotion.errors[:code], 'não pode ficar em branco'
    assert_includes promotion.errors[:discount_rate], 'não pode ficar em '\
                                                      'branco'
    assert_includes promotion.errors[:coupon_quantity], 'não pode ficar em'\
                                                        ' branco'
    assert_includes promotion.errors[:expiration_date], 'não pode ficar em'\
                                                        ' branco'
  end

  test 'code must be uniq' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.new(code: 'NATAL10')

    refute promotion.valid?
    assert_includes promotion.errors[:code], 'já está em uso'
  end

  test 'name must be uniq' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.new(name: 'Natal')

    refute promotion.valid?
    assert_includes promotion.errors[:name], 'já está em uso'
  end

  test 'generate coupons! successfully' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                expiration_date: '22/12/2033')
    promotion.generate_coupons!
    assert_equal promotion.coupons.size, promotion.coupon_quantity
    assert_equal promotion.coupons.first.code, 'NATAL10-0001'
  end

  test 'generate coupons! cannot be called twice' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                expiration_date: '22/12/2033')
                Coupon.create!(code: 'BLABLABLA', promotion: promotion)
    assert_no_difference 'Coupon.count' do
      promotion.generate_coupons!
    end
  end

  test 'coupons? has coupons' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                expiration_date: '22/12/2033')
                Coupon.create!(code: 'BLABLABLA', promotion: promotion)
    assert_equal promotion.coupons?, true
  end

  test 'coupons? does not have coupons' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                expiration_date: '22/12/2033')
    assert_not_equal promotion.coupons?, true
  end

  test '.search promotions by exact' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033')
    result = Promotion.search('Natal')
    assert_includes result, christmas
    refute_includes result, cyber_monday
    
  end

  test '.search promotions by partial' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                                  code: 'NATALINA10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033')
    result = Promotion.search('Natal')
    assert_includes result, christmas
    assert_includes result, christmassy
    refute_includes result, cyber_monday
    
  end

  test '.search finds nothing' do
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033')
    result = Promotion.search('Carnaval')
    assert_empty result
    
  end
end
