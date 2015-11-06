require 'rails_helper'

RSpec.describe Match, type: :model do
  before(:each) do
    @match = Fabricate(:match)
    @match.save
    playersA = @match.teamA.players
    playersB = @match.teamB.players
    i = 0
    playersA.each do |player|
      i+=1
      if i<=4
        player.fieldX = 20
        player.fieldY = 12*i
      elsif i<=8
        player.fieldX = 45
        player.fieldY = 12*(i -4)
      elsif i<=10
        player.fieldX = 75
        player.fieldY = 12*(i -7)
      elsif i==11
        player.fieldY = 30
        player.fieldX = 5
        player.is_goalie = true
      else
        player.fieldX = -1
        player.fieldY = -1
      end
    end
    i = 0
    playersB.each do |player|
      i+=1
      if i<=4
        player.fieldX = 20
        player.fieldY = 12*i
      elsif i<=8
        player.fieldX = 45
        player.fieldY = 12*(i -4)
      elsif i<=10
        player.fieldX = 75
        player.fieldY = 12*(i -7)
      elsif i==11
        player.fieldY = 30
        player.fieldX = 5
        player.is_goalie = true
      else
        player.fieldX = -1
        player.fieldY = -1
      end
    end
  end
  it "throws exception if match is not scheduled" do
    @match.status = :started
    expect{@match.simulate}.to raise_error(Match::BadStateException)
  end
  it "simulates match if match is scheduled" do
    @match.status = :scheduled
    expect{@match.simulate}.to_not raise_error
  end


end
