class AddWillPayDebtColumnToUserInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :user_infos, :will_pay_debt, :decimal
  end
end
