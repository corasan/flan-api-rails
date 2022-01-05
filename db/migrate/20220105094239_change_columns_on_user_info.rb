class ChangeColumnsOnUserInfo < ActiveRecord::Migration[7.0]
  def change
    rename_column :user_infos, :initial_checkings, :checking
    remove_column :user_infos, :initial_savings
    remove_column :user_infos, :loans
    remove_column :user_infos, :credit_cards
    add_column :user_infos, :debt, :decimal
  end
end
