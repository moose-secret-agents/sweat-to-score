class AddStatusToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :status, :integer, default: 0
  end
end
