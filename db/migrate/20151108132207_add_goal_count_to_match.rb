class AddGoalCountToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :scoreA, :integer, default: 0
    add_column :matches, :scoreB, :integer, default: 0
  end
end
