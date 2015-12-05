class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :team_status, default: 0
      t.integer :league_status, default: 0
      t.timestamps null: false
    end

    add_reference :invitations, :inviter, references: :users, index: true
    add_reference :invitations, :invitee, references: :users, index: true
  end
end
