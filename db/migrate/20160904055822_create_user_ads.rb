class CreateUserAds < ActiveRecord::Migration
  def change
    create_table :user_ads, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :user_id
      t.string :type, null: false
      t.integer :status_cd
      t.timestamps
    end
  end
end
