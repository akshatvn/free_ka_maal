class CreateUserPreferences < ActiveRecord::Migration
  def change
    create_table :user_preferences, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :user_id, foreign_key: true
      t.string :code
      t.string :value
      t.timestamps
    end
  end
end
