class AddOauthColsToUser < ActiveRecord::Migration
  def change
    add_column :users, :oauth_uid, :string
    add_column :users, :oauth_provider, :string, :limit => 20
  end
end
