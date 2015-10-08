class AddStatusToPartnership < ActiveRecord::Migration
  def change
    add_column :partnerships, :status, :integer, default: 0
  end
end
