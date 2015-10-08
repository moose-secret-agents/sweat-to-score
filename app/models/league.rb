class League < ActiveRecord::Base
  has_many :teams
  has_many :players, through: :teams
  validates_inclusion_of :level, in: 1..3
end
