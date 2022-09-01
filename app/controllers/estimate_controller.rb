# EstimateController
class EstimateController < ApplicationController
  before_action :authenticate_user
  before_action :auth_payload

  def initialize_user_info
    @user_info = user_info
  end

  def index
    initialize_user_info
    raise ActiveRecord::RecordNotFound if @user_info.nil?

    data = generate_data
    render json: {
      estimate: date_formatted_estimate(data),
      income_after_expenses: income_after_expenses,
      will_save: @user_info.will_save,
      will_pay_debt: will_pay_debt,
      debt_end: calc_debt_end
    }
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }
  end

  def income_after_expenses
    @user_info.income - @user_info.rent - expenses_total - @user_info.will_save - account_for_debt(@user_info.debt)
  end

  def chart
    raise ActiveRecord::RecordNotFound if @user_info.nil?

    render json: generate_data

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.to_s }
  end

  private

  def account_for_debt(debt)
    debt <= 0 ? 0.0 : will_pay_debt
  end

  def generate_data
    now = Time.now
    arr = [{ checking: @user_info.checking, savings: @user_info.savings, debt: @user_info.debt, month: now.month, year: now.year }]
    (0..range.to_i).each { |x| arr.push(est_object(arr[-1], now.month + x)) }
    arr
  end

  def date_formatted_estimate(arr)
    arr.group_by { |i| i[:year] }
  end

  # def est_object(prev, date_num)
  #   debt = calc_debt(prev[:debt])
  #   checking = calc_checking(prev[:checking], debt)
  #   savings = calc_savings(prev[:savings])
  #   {
  #     checking: checking,
  #     savings: savings,
  #     debt: debt <= 0 ? 0 : debt,
  #     prev_checking: prev[:checking],
  #     prev_savings: prev[:savings],
  #     prev_debt: prev[:debt] <= 0 ? 0 : prev[:debt],
  #     month: date_num.month.from_now.month,
  #     year: date_num.month.from_now.year,
  #     checking_change: diff(prev[:checking], checking),
  #     savings_change: diff(prev[:savings], savings),
  #     debt_change: debt <= 0 ? 0 : diff(prev[:debt], debt)
  #   }
  # end

  def calc_checking(num, debt_arg)
    num + @user_info.income - @user_info.rent - expenses_total - @user_info.will_save - account_for_debt(debt_arg)
  end

  def calc_savings(num)
    num + @user_info.will_save
  end

  def calc_debt(num)
    num - will_pay_debt
  end

  def calc_debt_end
    return 'Never' unless @user_info.debt.positive?

    counter = 0
    amount = @user_info.debt
    while amount.positive? && will_pay_debt.positive?
      amount -= will_pay_debt
      counter += 1
    end
    month = Date::MONTHNAMES[counter.month.from_now.month]
    "#{month}, #{counter.month.from_now.year}"
  end

  def estimate_checking_params
    params.permit(:range)
  end

  def user_info
    UserInfo.find_by user_id: @user.id
  end

  def expenses
    Expense.where(user_id: @user.id)
  end

  def expenses_total
    expenses.reject { |e| e.category == 'debt' }.sum(&:amount)
  end

  def range
    params[:range].nil? ? 3 : params[:range]
  end

  def will_pay_debt
    Expense.where(user_id: @user.id, category: 'debt').calculate(:sum, :amount)
  end

  def diff(num1, num2)
    (num1 - num2).abs
  end
end
