class AddTeamableReferenceToUsersAndPartnerships < ActiveRecord::Migration
  def change
    add_reference :teams, :teamable, polymorphic: true
  end
end
