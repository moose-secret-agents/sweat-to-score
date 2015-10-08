class Team < ActiveRecord::Base
  has_many :players

  after_create :assign_players

  def assign_players
    (11 + rand(14)).times do |i|
      players.create(name: "Player #{i}")
    end
  end
end
