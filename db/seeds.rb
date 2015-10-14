User.delete_all
League.delete_all
Team.delete_all
Player.delete_all

# Seed data

4.times do
  Fabricate(:user)
end

owner = User.first
league = Fabricate(:league, owner: owner)

User.all.each do |u|
  Fabricate(:team, teamable: u, league: league)
end




