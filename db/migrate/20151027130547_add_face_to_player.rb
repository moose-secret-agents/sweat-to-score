class AddFaceToPlayer < ActiveRecord::Migration
  def change
    add_column :players, :face, :json
  end
end
