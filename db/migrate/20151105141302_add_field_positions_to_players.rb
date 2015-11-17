class AddFieldPositionsToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :fieldX, :integer
    add_column :players, :fieldY, :integer
  end
end
