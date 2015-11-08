class ChangeDecimalsToFloatInPlayer < ActiveRecord::Migration
  def change
    change_column :players, :speed, :float, default: 10.0
    change_column :players, :stamina, :float, default: 10.0
    change_column :players, :fitness, :float, default: 10.0
    change_column :players, :goalkeep, :float, default: 10.0
    change_column :players, :defense, :float, default: 10.0
    change_column :players, :midfield, :float, default: 10.0
    change_column :players, :attack, :float, default: 10.0
    change_column :players, :strength, :float, default: 10.0
  end
end
