class SorceryCore < ActiveRecord::Migration
  def change
    remove_column :users, :password

    add_column :users, :username, :string
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string
    add_column :users, :remember_me_token, :string, :default => nil
    add_column :users, :remember_me_token_expires_at, :datetime, :default => nil

    add_index :users, :username, unique: true
    add_index :users, :remember_me_token
  end
end