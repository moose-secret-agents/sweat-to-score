class RemovePartnershipReferenceFromUsers < ActiveRecord::Migration
  def change
    remove_reference :users, :partnerships
  end
end
