class AddTargetAttributesToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :target, :integer
  end
end
