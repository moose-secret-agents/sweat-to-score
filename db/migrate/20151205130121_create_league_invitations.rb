class CreateLeagueInvitations < ActiveRecord::Migration
  def change
    create_table :league_invitations do |t|
      t.integer :status, default: 0
      t.timestamps null: false
    end

    add_reference :league_invitations, :user, references: :users, index: true
    add_reference :league_invitations, :invitee, references: :users, index: true
    add_reference :league_invitations, :league, references: :leagues, index: true
  end
end
