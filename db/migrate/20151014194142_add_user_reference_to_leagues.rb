class AddUserReferenceToLeagues < ActiveRecord::Migration
  def change
    add_reference :leagues, :owner, references: :users, index: true
  end
end
