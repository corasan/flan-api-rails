class CreateUserInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_infos do |t|
      t.decimal :rent
      t.decimal :income
      t.decimal :savings
      t.decimal :credit_cards
      t.decimal :loans
      t.decimal :initial_checkings
      t.decimal :initial_savings
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
