class AddBasicAttributesToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :speed, :decimal, default: 10.0
    add_column :players, :stamina, :decimal, default: 10.0
    add_column :players, :fitness, :decimal, default: 10.0
    add_column :players, :goalkeep, :decimal, default: 10.0
    add_column :players, :defense, :decimal, default: 10.0
    add_column :players, :midfield, :decimal, default: 10.0
    add_column :players, :attack, :decimal, default: 10.0
    add_column :players, :strength, :decimal, default: 10.0
  end
end
