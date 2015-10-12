class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :status, default: 0
      t.datetime :starts_at

      t.timestamps null: false
    end

    add_reference :matches, :league, references: :leagues, index: true
    add_reference :matches, :teamA, references: :teams, index: true
    add_reference :matches, :teamB, references: :teams, index: true
  end
end
