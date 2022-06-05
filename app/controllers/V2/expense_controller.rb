module V2
  class ExpenseController < ApplicationController
    def index
      render json: {expenses: all_expenses, total: total, pie_data: generate_pie_data}, status: :ok
    end

    def create
      expense = Expense.create({user_id: @user.id, **expense_params})

      if expense.invalid?
        render json: {error: expense.errors.objects.first.full_message}, status: :bad_request unless expense.valid?
      else
        render json: expense, status: :ok
      end
    end

    def update
      e = Expense.find_by id: params[:id]
      e.update(expense_params)
      e.save
      render json: e
    end

    def destroy
      exp = Expense.find_by id: params[:id]
      exp.destroy
    end

    private

    def expense_params
      params.permit([:name, :amount, :frequency, :category])
    end

    def all_expenses
      Expense.where user_id: @user.id
    end

    def total
      all_expenses.calculate(:sum, :amount)
    end

    def generate_pie_data
      def pie_data
        arr = []
        all_expenses.group_by(&:category).each_pair do |k, v|
          arr.push({ category: k, value: v.sum(&:amount) })
        end
        arr
      end
    end
  end
end

