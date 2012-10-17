class CreateMoneyAccounts < ActiveRecord::Migration
  def change
    create_table :money_accounts do |t|
      t.belongs_to :user
      t.integer :value, :limit => 8
      t.boolean :settlement, default: false
      t.boolean :enabled, default: true

      t.timestamps
    end
    add_index :money_accounts, [:user_id, :enabled]
  end
end
