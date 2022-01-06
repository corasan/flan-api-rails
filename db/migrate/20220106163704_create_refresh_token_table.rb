class CreateRefreshTokenTable < ActiveRecord::Migration[7.0]
  def change
    create_table :refresh_tokens do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :token

      t.timestamps
    end
  end
end
