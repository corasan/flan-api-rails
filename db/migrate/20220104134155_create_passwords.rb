class CreatePasswords < ActiveRecord::Migration[7.0]
  def change
    create_table :passwords do |t|
      t.string :value
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
