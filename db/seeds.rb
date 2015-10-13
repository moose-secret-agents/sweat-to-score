User.delete_all
League.delete_all
Team.delete_all

# Seed data

4.times do
  Fabricate(:user)
end

league = Fabricate(:league)

User.all.each do |u|
  Fabricate(:team, teamable: u, league: league)
end




