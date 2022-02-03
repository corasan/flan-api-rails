# ExpenseController
class ExpenseController < ApplicationController
  before_action :authenticate_user
  before_action :auth_payload

  def index
    expenses = all_expenses.map { |e| expense_object(e) }
    render json: { expenses: expenses, total: total, pie_data: pie_data }
  end

  def create
    exp_obj = { user_id: @user.id, **expense_params }
    render json: Expense.create(exp_obj)
  end

  def update
    e = Expense.find_by id: params[:id]
    e.update(expense_params)
    e.save
    render json: expense_object(e)
  end

  def destroy
    exp = Expense.find_by id: params[:id]
    exp.destroy
  end

  private

  def pie_data
    arr = []
    all_expenses.group_by(&:category).each_pair do |k, v|
      arr.push({ category: k, value: v.sum(&:amount) })
    end
    arr
  end

  def total
    all_expenses.sum(:amount)
  end

  def expense_params
    params.require(:expense).permit([:name, :amount, :frequency, :category, :id])
  end

  def expense_object(exp)
    {
      id: exp.id,
      name: exp.name,
      amount: exp.amount,
      category: exp.category,
      frequency: exp.frequency
    }
  end

  def all_expenses
    Expense.where user_id: @user.id
  end
end
