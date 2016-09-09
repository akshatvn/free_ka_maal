class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: false do |t|
      t.uuid :id, primary_key: true
      t.string :email, unique: true, null: false
      t.integer :credit_balance
      t.datetime :last_synced
      t.timestamps
    end
  end
end
