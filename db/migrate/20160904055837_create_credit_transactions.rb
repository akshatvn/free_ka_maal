class CreateCreditTransactions < ActiveRecord::Migration
  def change
    create_table :credit_transactions, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :user_id, foreign_key: true
      t.string :amount
      t.uuid :source_id
      t.string :source_type
      t.timestamps
    end
  end
end
