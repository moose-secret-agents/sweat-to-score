class CreatePartnerships < ActiveRecord::Migration
  def change
    create_table :partnerships do |t|
      t.timestamps null: false
    end

    add_reference :partnerships, :user, references: :users, index: true
    add_reference :partnerships, :partner, references: :users, index: true
  end
end
