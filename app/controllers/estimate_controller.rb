# EstimateController
class EstimateController < ApplicationController
  before_action :authorized

  def initialize_estimate
    @income = income
    @checking = checking
    @savings = savings
    @debt = debt
    @rent = rent
    @will_save = will_save
    @will_pay_debt = will_pay_debt
    @expenses_total = expenses_total
  end

  def index
    initialize_estimate

    data = generate_data
    render json: {
      estimate: date_formatted_estimate(data),
      income_after_expenses: income_after_expenses,
      will_save: @will_save,
      will_pay_debt: @will_pay_debt,
      debt_end: calc_debt_end
    }
  end

  def income_after_expenses
    @income - @will_save - @will_pay_debt - @expenses_total
  end

  def chart
    initialize_estimate
    render json: generate_data
  end

  private

  def generate_data
    now = Time.now
    arr = [{ checking: @checking, savings: @savings, debt: @debt, month: now.month, year: now.year }]
    (0..range.to_i).each { |x| arr.push(est_object(arr[-1], now.month + x)) }
    arr
  end

  def date_formatted_estimate(arr)
    arr.group_by { |i| i[:year] }
  end

  def est_object(prev, date_num)
    debt = calc_debt(prev[:debt])
    {
      checking: calc_checking(prev[:checking], debt),
      savings: calc_savings(prev[:savings]),
      debt: debt <= 0 ? 0 : debt,
      prev_checking: prev[:checking],
      prev_savings: prev[:savings],
      prev_debt: prev[:debt] <= 0 ? 0 : prev[:debt],
      month: date_num.month.from_now.month,
      year: date_num.month.from_now.year
    }
  end

  def calc_checking(num, debt)
    account_for_debt = debt <= 0 ? 0 : @will_pay_debt
    num + @income - @rent - @expenses_total - account_for_debt - @will_save
  end

  def calc_savings(num)
    num + @will_save
  end

  def calc_debt(num)
    num - @will_pay_debt
  end

  def calc_debt_end
    return nil unless @debt.positive?

    now = Time.now
    counter = now.month
    amount = @debt

    while amount.positive?
      amount -= @will_pay_debt
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

  def rent
    user_info.rent
  end

  def savings
    user_info.savings
  end

  def checking
    user_info.checking
  end

  def income
    user_info.income
  end

  def debt
    user_info.debt
  end

  def expenses
    Expense.where(user_id: @user.id)
  end

  def expenses_total
    expenses.sum(:amount)
  end

  def range
    params[:range].nil? ? 3 : params[:range]
  end

  def will_save
    user_info.will_save
  end

  def will_pay_debt
    user_info.will_pay_debt
  end
end
