class AddPwToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pw, :text
  end
end
