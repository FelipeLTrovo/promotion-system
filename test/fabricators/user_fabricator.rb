Fabricator(:user)do
    email { sequence(:email) {|i| "jane.doe#{i}@iugu.com.br"}}
    password '123456'
    name { sequence(:name) {|i| "Jane Doe#{i}"}}
end