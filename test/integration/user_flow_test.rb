require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest

    test 'cannot cancel own account without login' do
        user = User.create!(email: "campuscode@iugu.com.br", name: "Campus Code", password: "123456")
        
        delete user_registration_path(user)
        assert_equal 'Para continuar, efetue login ou registre-se.', response.body
        assert_response :unauthorized
    end

end