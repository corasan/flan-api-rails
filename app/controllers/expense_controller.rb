# ExpenseController
class ExpenseController < ApplicationController
  before_action :authorized

  def index
    exps = Expense.where user_id: @user.id
    expenses = exps.map { |e| expense_object(e) }
    render json: expenses
  end

  def create
    exp_obj = { user_id: @user.id, **expense_params }
    e = Expense.create(exp_obj)
    render json: expense_object(e)
  end

  def update
    puts "THESE ARE THE PARAMS -> #{params}"
    e = Expense.find_by id: params[:id]
    e.update(expense_params)
    e.save
    render json: expense_object(e)
  end

  private

  def expense_params
    params.require(:expense).permit(%i[name amount frequency category id])
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
end
