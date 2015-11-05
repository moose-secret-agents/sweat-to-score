class RemoveAttributesFromUsers < ActiveRecord::Migration
  def change
    remove_columns :users, :email, :name
  end
end
