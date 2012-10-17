class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :money, limit: 8

      t.timestamps
    end
  end
end
