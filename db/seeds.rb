# Delete all
[User, League, Team, Player, Partnership, TeamInvitation, LeagueInvitation].each(&:delete_all)

# Seed admin
admin = Fabricate(:user, username: 'stsadmin', password: 'stsadmin', password_confirmation: 'stsadmin', pw: 'stsadmin')
# Seed standard user
Fabricate(:user, username: 'test', password: 'test', password_confirmation: 'test', pw: 'test', real_name: 'Test User')
# Seed some users
(1..3).each do |n|
  username = "stsuser#{n}"
  Fabricate(:user, username: username, password: username, password_confirmation: username, pw: username,
            real_name: "STS User #{n}", email: "user#{n}@sts.org")
end

3.times do |i|
  league = Fabricate(:league, owner: admin)

  User.all.each do |u|
    Fabricate(:team, teamable: u, league: league)
  end
end





