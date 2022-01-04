class ExpenseTest < ActiveSupport::TestCase
  test_user = User.find_by email: 'test@gmail.com'

  test 'can create an expense' do
    exp = Expense.new(name: 'Expense Two', frequency: 'monthly', amount: 10.99, user_id: test_user.id)
    exp.save
    assert Expense.find_by id: exp.id
  end

  test "can't create expense if name is missing" do
    exp = Expense.new(frequency: 'monthly', amount: 10.99, user_id: test_user.id)
    assert_not exp.save
  end

  test "can't create expense if amount is missing" do
    exp = Expense.new(name: 'Expense Two', frequency: 'monthly', user_id: test_user.id)
    assert_not exp.save
  end

  test "can't create expense if frequency is missing" do
    exp = Expense.new(name: 'Expense Two', amount: 10.99, user_id: test_user.id)
    assert_not exp.save
  end
end
