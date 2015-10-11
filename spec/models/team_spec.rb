require 'rails_helper'

RSpec.describe Team, type: :model do

  before(:all) do
    User.delete_all
    Team.delete_all
    @user = User.create!(name: 'User')
    @league = League.create!(level: 2)
    @team = Team.create!(name: 'Transis', strength: 50, league: @league, teamable: @user)

  end

  it 'should raise error if no name' do
    expect(Team.create(teamable: @user, strength: 50, league: @league)).to_not be_valid
  end

  it 'should raise error if no teamable' do
    expect(Team.create(name: 'team', strength: 50, league: @league)).to_not be_valid
  end

  it 'should raise error if no league' do
    expect(Team.create(name: 'team', teamable: @user, strength: 50)).to_not be_valid
  end

  it 'should have a team name' do
    expect(@team.name).to eq('Transis')
  end

  it 'should have a league' do
    expect(@team.league).to eq(@league)
  end

  it 'should have a teamable' do
    expect(@team.teamable).to eq(@user)
  end

  it 'should have 11-25 players' do
    expect(@team.players.count).to be_between(11, 25)
  end

end
