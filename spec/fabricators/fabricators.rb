Fabricator(:user) do
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
end

Fabricator(:league) do
  name  { "#{Faker::Team.name} League" }
  level { Faker::Number.between(1, 3) }
  owner(fabricator: :user)
end

Fabricator(:player) do
  name { Faker::Name.name }
  talent { Faker::Number.between(0, 100) }
end

Fabricator(:team) do
  name { Faker::Team.name }
  strength { Faker::Number.between(0, 100) }
  teamable(fabricator: :user)
  league
  players { (11..25).to_a.sample.times.map { Fabricate(:player) } }
end
