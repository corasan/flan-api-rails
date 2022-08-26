module V2
  include ActiveSupport::Concern

  class EstimateController < ApplicationController
    before_action :check_user_info

    @user_info

    def index
      data = generate_data
      render json: {
        estimate: date_formatted_estimate(data),
        income_after_expenses: income_after_expenses,
        will_save: @user_info.will_save,
        amount_towards_debt: amount_towards_debt,
        debt_end: calc_debt_will_end
      }, status: :ok
    end

    def chart
      raise ActiveRecord::RecordNotFound if @user_info.nil?

      render json: generate_data, status: :ok

    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.to_s }, status: :no_content
    end

    def estimate_params
      params.permit(:range)
    end

    private

    def income_after_expenses
      @user_info.income - @user_info.rent - expenses_total - @user_info.will_save - account_for_debt(@user_info.debt)
    end

    def date_formatted_estimate(arr)
      arr.group_by { |i| i[:year] }
    end

    def account_for_debt(debt)
      debt <= 0 ? 0.0 : amount_towards_debt
    end

    def generate_data
      now = Time.now
      arr = [{ checking: @user_info.checking, savings: @user_info.savings, debt: @user_info.debt, month: now.month, year: now.year }]
      (1..range.to_i).each { |x| arr.push(est_object(arr[-1], x.month.from_now.month, x.month.from_now.year)) }
      arr
    end

    # @param [Object] prev
    # @param [Number] month
    # @param [Number] year
    def est_object(prev, month, year)
      debt = calc_debt(prev[:debt])
      checking = calc_checking(prev[:checking], debt)
      savings = calc_savings(prev[:savings])
      {
        checking: checking,
        savings: savings,
        debt: debt <= 0 ? 0 : debt,
        prev_checking: prev[:checking],
        prev_savings: prev[:savings],
        prev_debt: prev[:debt] <= 0 ? 0 : prev[:debt],
        month: month,
        year: year,
        checking_change: diff(prev[:checking], checking),
        savings_change: diff(prev[:savings], savings),
        debt_change: debt <= 0 ? 0 : diff(prev[:debt], debt)
      }
    end

    def calc_checking(num, debt_arg)
      num + @user_info.income - @user_info.rent - expenses_total - @user_info.will_save - account_for_debt(debt_arg)
    end

    def calc_savings(num)
      num + @user_info.will_save
    end

    def calc_debt(num)
      num - amount_towards_debt
    end

    def calc_debt_will_end
      return 'Never' unless @user_info.debt.positive?

      counter = 0
      amount = @user_info.debt
      while amount.positive? && amount_towards_debt.positive?
        amount -= amount_towards_debt
        counter += 1
      end
      month = Date::MONTHNAMES[counter.month.from_now.month]
      "#{month}, #{counter.month.from_now.year}"
    end

    def check_user_info
      info = UserInfo.find_by user_id: @user.id
      raise ActiveRecord::RecordNotFound if info.nil?

      @user_info = info
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.to_s }, status: :no_content
    end

    def expenses
      Expense.where user_id: @user.id
    end

    def expenses_total
      expenses.reject { |e| e.category == 'debt' }.sum(&:amount)
    end

    def range
      params[:range].nil? ? 3 : params[:params]
    end

    def amount_towards_debt
      Expense.where(user_id: @user.id, category: 'debt').calculate(:sum, :amount)
    end
  end
end
