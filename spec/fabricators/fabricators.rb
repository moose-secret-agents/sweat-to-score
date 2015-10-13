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
