module V2
  class EstimateController < ApplicationController
    def index

    end

    def estimate_params
      params.permit(:range)
    end

    private

    def debt_end
      return 'Never' unless user_info.debt.positive?

      counter = 0
      amount = user_info.debt
      while amount.positive? && will_pay_debt.positive?
        amount -= will_pay_debt
        counter += 1
      end
      month = Date::MONTHNAMES[counter.month.from_now.month]
      "#{month}, #{counter.month.from_now.year}"
    end

    def user_info
      UserInfo.find_by user_id: @user.id
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

    def will_pay_debt
      Expense.where(user_id: @user.id, category: 'debt').calculate(:sum, :amount)
    end
  end
end
