Fabricator(:user) do
  username { Faker::Internet.user_name }
  real_name { Faker::Name.name }
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  password_confirmation { |u| u[:password] }
  pw { |u| u[:pasword] }
end

Fabricator(:league) do
  name  { "#{Faker::Team.name} League" }
  level { Faker::Number.between(1, 3) }
  target {100}
  owner(fabricator: :user)
end

Fabricator(:player, fieldX: 0, fieldY:0) do
  name { Faker::Name.name }
  talent { Faker::Number.between(30, 100) }

  fitness { Faker::Number.between(30, 50) }
  goalkeep { Faker::Number.between(30, 50) }
  defense { Faker::Number.between(30, 50) }
  midfield { Faker::Number.between(30, 50) }
  attack { Faker::Number.between(30, 50) }

  stamina { Faker::Number.between(70, 95) }
end

Fabricator(:team) do
  name { Faker::Team.name }
  strength { Faker::Number.between(0, 100) }
  points { Faker::Number.between(0, 100) }
  teamable(fabricator: :user)
  league
  positionsX = [1,20,20,20,20,45,45,45,45,75,75,-1,-1,-1,-1,-1]
  positionsY = [30,12,24,36,48,12,24,36,48,24,36,-1,-1,-1,-1,-1]
  players { Team::DEFAULT_PLAYER_COUNT.times.map do |i| Fabricate(:player, {fieldX: positionsX[i], fieldY: positionsY[i]}) end }
end

Fabricator(:match) do
  league(fabricator: :league)
  teamA(fabricator: :team)
  teamB(fabricator: :team)
  status {Match.statuses[:scheduled]}

end
