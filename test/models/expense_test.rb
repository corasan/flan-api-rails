class ExpenseTest < ActiveSupport::TestCase
  test_user = User.find_by email: 'test@gmail.com'
  test_expense = Expense.find_by name: 'Expense One'

  puts test_user.id

  test 'can create an expense' do
    exp = Expense.create(name: 'Expense Two', frequency: 'monthly', amount: 10.99, user_id: test_user.id)
    assert exp.valid?
  end

  test "can't create expense if name is missing" do
    exp = Expense.create(frequency: 'monthly', amount: 10.99, user_id: test_user.id)
    assert_not exp.valid?
  end

  test "can't create expense if amount is missing" do
    exp = Expense.create(name: 'Expense Two', frequency: 'monthly', user_id: test_user.id)
    assert_not exp.valid?
  end

  test "can't create expense if frequency is missing" do
    exp = Expense.create(name: 'Expense Two', amount: 10.99, user_id: test_user.id)
    assert_not exp.valid?
  end

  test 'can update expense' do
    puts test_expense.name
    test_expense.update name: 'Changed expense name'
    test_expense.save
    assert test_expense.name == 'Changed expense name'
  end
end
