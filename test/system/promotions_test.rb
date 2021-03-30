# promotion-system/test/system/promotions_test.rb

require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
    
    

    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)


    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma Promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_user

    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code/name must be unique' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)


    visit root_path
    click_on 'Promoções'
    click_on 'Registrar Promoção'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Nome', with: 'Natal'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupons for a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)


    visit promotion_path(promotion)
    click_on "Gerar Cupons"

    assert_text "Cupons gerados com sucesso"

    assert_no_link "Gerar cupons"
    assert_no_text "NATAL10-0000 (ativo)"
    assert_text "NATAL10-0001 (ativo)"
    assert_text "NATAL10-0002 (ativo)"
    assert_text "NATAL10-0100 (ativo)"
    assert_no_text "NATAL10-0101 (ativo)"
    assert_link "Desabilitar", count: 100
    

  end

  test 'update promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit edit_promotion_path(promotion)
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Atualizar Promoção'

    assert_current_path promotion_path(promotion)
    assert_text "Promoção editada com sucesso"
    assert_text "Cyber Monday"
    assert_no_text "Natal"
  end

  test 'update promotion and attributes cannot be blank' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    visit edit_promotion_path(promotion)
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Atualizar Promoção'

    assert_current_path promotion_path(promotion)
    assert_no_text "Promoção editada com sucesso"
    assert_text 'não pode ficar em branco', count: 5
  end

  test 'update promotion and code/name must be unique' do
    user = login_user
                      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    edit_promotion =  Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)

    
    visit edit_promotion_path(edit_promotion)
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Atualizar Promoção'
    assert_text 'já está em uso', count: 2
  end

  test 'delete promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    coupon =    Coupon.create!(code: "#{promotion.code}-#{'%04d' % promotion.coupon_quantity}", promotion: promotion)
    promotion.coupons << coupon
    visit promotions_path
    click_on 'Deletar Promoção'
    assert_text 'Nenhuma Promoção cadastrada'
  end

  test 'search promotions by term and finds results' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                                  code: 'NATALINA10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text christmas.name
    assert_text christmassy.name
    assert_no_text cyber_monday.name
  end
  
  # TODO não encontra nada
  test 'search promotions by term and finds nothing' do
    user = login_user
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                                  code: 'NATALINA10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'carnaval'
    click_on 'Buscar'

    assert_no_text christmas.name
    assert_no_text christmassy.name
    assert_no_text cyber_monday.name
    assert_text 'Nenhuma Promoção cadastrada'
  end

  # TODO acessar pagina de busca sem estar logado
  test 'do not search promotions by term using route without login' do
    visit search_promotions_path
    assert_no_link 'Buscar'
    assert_current_path new_user_session_path
  end

  # TODO visit search_promotions(q: 'natal')
  test 'do not search promotions by params using route without login' do
    user = User.create!(email: "johndoe@hotmail.com", password: "123456")
    christmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de Natal',
                                  code: 'NATALINA10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    cyber_monday = Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                                     description: 'Promoção de Cyber Monday',
                                     code: 'CYBER15', discount_rate: 15,
                                     expiration_date: '22/12/2033', user: user)

    visit search_promotions_path(q: 'natal')

    assert_no_text christmas.name
    assert_no_text christmassy.name
    assert_no_text cyber_monday.name

    assert_current_path new_user_session_path
  end

  test 'user approve promotion' do
    user = User.create!(email: "janedoe@iugu.com.br", password: "123456")
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    approver = login_user
    visit promotion_path(promotion)
    accept_confirm { click_on 'Aprovar' }

    assert_text 'Promoção aprovada com sucesso'
    assert_text "Aprovada por: #{approver.email}"
    assert_link 'Gerar Cupons'
  end

  test 'do not view promotion link without login' do
    visit root_path

    assert_no_link 'Promoções'
  end

  test 'do not view promotions using route without login' do 
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test 'do view promotion details without login' do
    user = User.create!(email: "johndoe@hotmail.com", password: "123456")
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'cannot create promotion without login' do
    visit new_promotion_path

    assert_current_path new_user_session_path
  end

end