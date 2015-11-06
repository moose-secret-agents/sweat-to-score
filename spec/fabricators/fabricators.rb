Fabricator(:user) do
  username { Faker::Internet.user_name }
  name { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  password_confirmation { |u| u[:password] }
end

Fabricator(:league) do
  name  { "#{Faker::Team.name} League" }
  level { Faker::Number.between(1, 3) }
  owner(fabricator: :user)
end

Fabricator(:player) do
  name { Faker::Name.name }
  talent { Faker::Number.between(0, 100) }
  fieldX {Faker::Number.between(0, 100)}
  fieldY {Faker::Number.between(0 , 60)}
end

Fabricator(:team) do
  name { Faker::Team.name }
  strength { Faker::Number.between(0, 100) }
  points { Faker::Number.between(0, 100) }
  teamable(fabricator: :user)
  league
  players { (18..25).to_a.sample.times.map { Fabricate(:player) } }
end

Fabricator(:match) do
  league(fabricator: :league)
  teamA(fabricator: :team)
  teamB(fabricator: :team)
  status {Match.statuses[:scheduled]}
  rand {Random.new(115032730400174366788466674494640623225)}
end
