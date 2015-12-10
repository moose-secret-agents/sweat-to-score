class CreateTeamInvitations < ActiveRecord::Migration
  def change
    create_table :team_invitations do |t|
      t.integer :status, default: 0
      t.timestamps null: false
    end

    add_reference :team_invitations, :user, references: :users, index: true
    add_reference :team_invitations, :invitee, references: :users, index: true
    add_reference :team_invitations, :team, references: :teams, index: true
  end
end
