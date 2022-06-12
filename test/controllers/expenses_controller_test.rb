require "test_helper"

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test 'Can get all user expenses' do
    get '/v2/expenses', headers: req_headers
    assert_response :ok
  end

  test 'Can create and expense' do
    post '/v2/expenses', params: create_payload, headers: req_headers
    assert_response :ok
  end

  test 'Cannot create expense with bad request' do
    post '/v2/expenses', params: bad_create_payload, headers: req_headers
    assert_response :bad_request
  end

  test 'Can delete expense' do
    delete '/v2/expenses', params: {id: 360}, headers: req_headers
    assert_response :no_content
  end

  test 'Can edit expense' do
    put '/v2/expenses', params: {id: 361, amount: 15.67}, headers: req_headers
    assert_response :ok
  end

  private

  def create_payload
    {name: 'An expense', category: :debt, amount: 200, frequency: :weekly}
  end

  def bad_create_payload
    {name: 'An expense', category: :debt, frequency: :weekly}
  end
end
