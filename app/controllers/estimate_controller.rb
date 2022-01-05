# EstimateController
class EstimateController < ApplicationController
  before_action :authorized

  # def index
  #
  # end

  def estimate_checking
    month = Time.now.month
    arr = [{ checking: checking, savings: savings, debt: debt, month: month }]
    (1..range).each do |x|
      arr.push(est_object(arr[-1], month + x))
    end

    render json: { estimate: arr }
  end

  private

  def est_object(prev, month)
    {
      checking: calc_checking(prev[:checking]),
      savings: calc_savings(prev[:savings]),
      debt: calc_debt(prev[:debt]),
      prev_checking: prev[:checking],
      prev_savings: prev[:savings],
      prev_debt: prev[:debt],
      month: month
    }
  end

  def calc_checking(num)
    num + income - rent - expenses_total - will_pay_debt - will_save
  end

  def calc_savings(num)
    num + will_save
  end

  def calc_debt(num)
    num - will_pay_debt
  end

  def estimate_checking_params
    params.permit(%i[range])
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
