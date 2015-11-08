class AddSchedulingAttributesToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :starts_at, :datetime
    add_column :leagues, :league_length, :integer
    add_column :leagues, :pause_length, :integer
  end
end
