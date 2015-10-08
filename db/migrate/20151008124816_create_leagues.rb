class CreateLeagues < ActiveRecord::Migration
  def change
    create_table :leagues do |t|
      t.string :name
      t.integer :level

      t.timestamps null: false
    end

    add_reference :teams, :league, index: true
  end
end
