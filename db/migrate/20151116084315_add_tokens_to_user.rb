class AddTokensToUser < ActiveRecord::Migration
  def change
    add_column :users, :tokens, :integer, default: 0
  end
end
