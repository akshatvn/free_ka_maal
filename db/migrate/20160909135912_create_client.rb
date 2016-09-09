class CreateClient < ActiveRecord::Migration
  def change
    create_table :clients, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :user_id, foreign_key: true
      t.string :auth_token
      t.timestamps
    end
  end
end
