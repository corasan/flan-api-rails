class UserControllerTest < ActionDispatch::IntegrationTest
  user_params = { email: 'test@gmail.com', password: '12345678' }
  test 'should create user' do
    user = User.create(user_params)

    assert User.find_by id: user.id
  end

  test 'fail to create user if password is shorter than 8 characters' do
    user = User.new(email: 'test@gmail.com', password: '123456')
    assert_not user.save
  end
end
