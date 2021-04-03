module LoginMacros
    def login_user(user = User.create!(email: 'jane.doe@iugu.com.br', name: 'Jane Doe', password: '123456'))
      login_as user, scope: :user
      user
    end
  end