class AddDefaultPositionToPlayers < ActiveRecord::Migration
  def change
    change_column :players, :fieldX, :integer, default: 0
    change_column :players, :fieldY, :integer, default: 0
  end
end
