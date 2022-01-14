class RemoveWillPayDebtColumnFromUserInfo < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_infos, :will_pay_debt, :decimal
  end
end
