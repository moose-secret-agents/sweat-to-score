User.delete_all
League.delete_all
Team.delete_all

Fabricator(:user) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
end

Fabricator(:league) do
  name  { "#{Faker::Team.name} League" }
  level { Faker::Number.between(1, 3) }

end

Fabricator(:team) do
  name { Faker::Team.name }
  strength { Faker::Number.between(0, 100) }
  teamable(fabricator: :user)
  league
end

# Seed data

4.times do
  Fabricate(:user)
end

league = Fabricate(:league)

User.all.each do |u|
  Fabricate(:team, teamable: u, league: league)
end




