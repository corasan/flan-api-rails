# ExpenseController
class ExpenseController < ApplicationController
  before_action :authorized

  def index
    expenses = all_expenses.map { |e| expense_object(e) }
    render json: { expenses: expenses, total: total }
  end

  def create
    exp_obj = { user_id: @user.id, **expense_params }
    render json: Expense.create(exp_obj)
  end

  def update
    puts "THESE ARE THE PARAMS -> #{params}"
    e = Expense.find_by id: params[:id]
    e.update(expense_params)
    e.save
    render json: expense_object(e)
  end

  private

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
