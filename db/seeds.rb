User.delete_all
League.delete_all
Team.delete_all
Player.delete_all

# Seed data

4.times do
  Fabricate(:user)
end

3.times do |i|
  owner = if i == 0
            User.first
          else
            User.all.sample
          end
  league = Fabricate(:league, owner: owner)

  User.all.each do |u|
    Fabricate(:team, teamable: u, league: league)
  end
end





