require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
    test 'user sign up' do
        visit root_path
        click_on 'Cadastrar'
        fill_in 'Email', with: 'john.doe@iugu.com.br'
        fill_in 'Senha', with: 'password'
        fill_in 'Confirmação de senha', with: 'password'
        within 'form' do
            click_on 'Cadastrar'
        end

        assert_text 'Boas vindas! Cadastrou e entrou com sucesso.'
        assert_text 'john.doe@iugu.com.br'
        assert_link 'Sair'
        assert_no_link 'Cadastrar'
        assert_current_path root_path
    end
    
    test 'user sign in' do 
        user = User.create!(email: 'john.doe@iugu.com.br', password: 'password')

        visit root_path
        click_on 'Entrar'
        fill_in 'Email', with: user.email
        fill_in 'Senha', with: user.password
        click_on 'Log in'

        assert_text 'Login efetuado com sucesso!'
        assert_current_path root_path
        assert_link 'Sair'
        assert_no_link 'Entrar'
    end

    #TODO Teste de sair
    #TODO Teste de falha ao registrar
    #TODO Teste de falhar ao logar
    #TODO Teste de recuperar senha
    test 'user reset password' do
        user = User.create!(name: 'Jane Doe', email: 'jane.doe@iugu.com.br', password: 'password')
        token = user.send_reset_password_instructions
        visit edit_user_password_path(reset_password_token: token)
        
        fill_in 'Nova Senha', with: 'newpassword'
        fill_in 'Confirme sua nova senha', with: 'newpassword'
        click_on 'Alterar minha senha'
        assert_text 'Sua senha foi alterada com sucesso. Você está logado.'
        end 
    #TODO Teste de editar user
    #TODO I18n do user
    #TODO Incluir name no user
end