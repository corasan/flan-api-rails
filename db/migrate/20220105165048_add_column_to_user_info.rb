class AddColumnToUserInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :user_infos, :will_save, :decimal
  end
end
