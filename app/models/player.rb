class Player < ActiveRecord::Base
  belongs_to :team
  validates_inclusion_of :talent, in: 0..100
end
