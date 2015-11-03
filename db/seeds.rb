User.delete_all
League.delete_all
Team.delete_all
Player.delete_all

# Seed data

4.times do
  Fabricate(:user, password: 'pass', password_confirmation: 'pass')
end

# Seed standard user
Fabricate(:user, username: 'test', password: 'test', password_confirmation: 'test', name: 'Test User')

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





