class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.string :name
      t.decimal :amount
      t.string :category
      t.string :frequency
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
