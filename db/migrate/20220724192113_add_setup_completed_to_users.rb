class AddSetupCompletedToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :setup_completed, :boolean
  end
end
