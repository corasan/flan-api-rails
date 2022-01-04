class UserTest < ActiveSupport::TestCase
  user_params = { email: 'test2@gmail.com' }
  test 'should create user' do
    user = User.create(user_params)
    assert User.find_by id: user.id
  end

  test 'fail to create user if no email' do
    user = User.new(email: nil)
    assert_not user.save
  end
end
