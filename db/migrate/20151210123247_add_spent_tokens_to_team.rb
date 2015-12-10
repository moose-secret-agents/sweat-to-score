class AddSpentTokensToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :spent_tokens, :integer, default: 0
  end
end
