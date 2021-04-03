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
        user = User.create!(email: 'john.doe@iugu.com.br', name:"John Doe", password: 'password')
        
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
    
    #TODO Teste de falha ao registrar
    test 'user signup with blank parameters' do
        visit root_path
        click_on 'Cadastrar'
        fill_in 'Email', with: ''
        fill_in 'Senha', with: ''
        fill_in 'Confirmação de senha', with: ''
        within 'form' do
            click_on 'Cadastrar'
        end
        
        assert_no_text 'Boas vindas! Cadastrou e entrou com sucesso.'
        assert_text 'Email não pode ficar em branco'
        assert_text 'Senha não pode ficar em branco'
        assert_no_link 'Sair'
        assert_link 'Cadastrar'
        assert_current_path user_registration_path	
    end
    
    #TODO Teste de falhar ao logar
    test 'user sign with invalid parameters' do 
        visit root_path
        click_on 'Entrar'
        fill_in 'Email', with: 'john.doe@iugu.com.br'
        fill_in 'Senha', with: 'password'
        click_on 'Log in'
        

        assert_text 'Email ou senha inválida.'
        assert_button 'Log in'
        assert_no_link 'Sair'
        
        assert_current_path new_user_session_path
    end

    test 'user signup with short password' do
        visit root_path
        click_on 'Cadastrar'
        fill_in 'Email', with: 'campuscode@iugu.com.br'
        fill_in 'Senha', with: '123'
        fill_in 'Confirmação de senha', with: '123'
        within 'form' do
            click_on 'Cadastrar'
        end

        assert_no_text 'Boas vindas! Cadastrou e entrou com sucesso.'
        assert_text 'Senha é muito curto (mínimo: 6 caracteres)'
        assert_no_link 'Sair'
        assert_link 'Cadastrar'
        assert_current_path user_registration_path	
    end

    test 'user signup with password and password confirmation do not match' do
        visit root_path
        click_on 'Cadastrar'
        fill_in 'Email', with: 'campuscode@iugu.com.br'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirmação de senha', with: 'abcdef'
        within 'form' do
            click_on 'Cadastrar'
        end

        assert_no_text 'Boas vindas! Cadastrou e entrou com sucesso.'
        assert_text 'Confirmação da senha não é igual a Senha'
        assert_no_link 'Sair'
        assert_link 'Cadastrar'
        assert_current_path user_registration_path	
    end

    #TODO Teste de sair
    test 'user logout' do
        login_user

        visit root_path
        click_on 'Sair'

        assert_text 'Saiu com sucesso.'
        assert_no_text 'Sair'
        assert_text 'Entrar'

    end

    #TODO Teste de recuperar senha
    test 'user reset password' do
        user = User.create!(email: 'jane.doe@iugu.com.br', name: 'Jane Doe', password: 'password')
        token = user.send_reset_password_instructions
        visit edit_user_password_path(reset_password_token: token)
        
        fill_in 'Nova senha', with: 'newpassword'
        fill_in 'Confirme sua nova senha', with: 'newpassword'
        click_on 'Alterar minha senha'
        assert_text 'Sua senha foi alterada com sucesso. Você está logado.'
        end 

    #TODO Teste de editar user
    test 'user edit attributes' do
        user = User.create!(email: 'jane.doe@iugu.com.br', name: 'Jane Doe', password: 'password')
        login_user(user)
        visit root_path

        click_on 'jane.doe@iugu.com.br'
        fill_in 'Email', with: 'campuscode@iugu.com.br'
        fill_in 'Name', with: 'Campus Code'
        fill_in 'Senha', with: 'newpassword'
        fill_in 'Confirmação da senha', with: 'newpassword'
        fill_in 'Current password', with: 'password'
        click_on 'Update'

        assert_text 'Sua conta foi atualizada com sucesso.'
        assert_link 'campuscode@iugu.com.br'
        assert_no_link 'jane.doe@iugu.com.br'

        assert_current_path root_path
    end

    test 'user edit attributes with blank parameters' do
        user = User.create!(email: 'jane.doe@iugu.com.br', name:"Jane Doe", password: 'password')
        login_user(user)
        visit root_path

        click_on 'jane.doe@iugu.com.br'
        click_on 'Update'

        assert_no_text 'Sua conta foi atualizada com sucesso.'
        assert_text 'Current password não pode ficar em branco'

        assert_current_path user_registration_path	
    end

    test 'user edit attributes with short password' do
        user = User.create!(email: 'jane.doe@iugu.com.br', name: 'Jane Doe', password: 'password')
        login_user(user)
        visit root_path

        click_on 'jane.doe@iugu.com.br'
        fill_in 'Email', with: 'campuscode@iugu.com.br'
        fill_in 'Name', with: 'Campus Code'
        fill_in 'Senha', with: '123'
        fill_in 'Confirmação da senha', with: '123'
        fill_in 'Current password', with: 'password'
        click_on 'Update'

        assert_no_link 'campuscode@iugu.com.br'
        assert_no_text 'Sua conta foi atualizada com sucesso.'
        assert_text 'Senha é muito curto (mínimo: 6 caracteres)'

        assert_current_path user_registration_path
    end

    test 'user edit attributes with password and password confirmation do not match' do
        user = User.create!(email: 'jane.doe@iugu.com.br', name: 'Jane Doe', password: 'password')
        login_user(user)
        visit root_path

        click_on 'jane.doe@iugu.com.br'
        fill_in 'Email', with: 'campuscode@iugu.com.br'
        fill_in 'Name', with: 'Campus Code'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirmação da senha', with: 'abcdef'
        fill_in 'Current password', with: 'password'
        click_on 'Update'

        assert_no_link 'campuscode@iugu.com.br'
        assert_no_text 'Sua conta foi atualizada com sucesso.'
        assert_text 'Confirmação da senha não é igual a Senha'

        assert_current_path user_registration_path
    end
    #TODO I18n do user
    #TODO Incluir name no user
end