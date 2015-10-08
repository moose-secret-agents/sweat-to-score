require 'rails_helper'

RSpec.describe League, type: :model do

  before(:all) do
    @league = League.create!(name: 'LoserLeague', level: 3)
    @team = @league.teams.create!(name: 'Test Team', strength: 55)
  end

  it 'should have a name' do
    expect(@league.name).to eq('LoserLeague')
  end

  it 'should have a level between 1-3' do
    expect(@league.level).to be_between(1, 3)
  end

  it 'should have a team' do
    expect(@league.teams.count).to be > 0
  end

  it 'should have players through team' do
    expect(@league.players.count).to be > 0
  end
end
