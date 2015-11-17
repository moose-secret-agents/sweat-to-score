require 'rails_helper'

RSpec.describe League, type: :model do

  before(:all) do
    @league = League.create!(name: 'LoserLeague', level: 3)
    @user=User.create(name: 'Owner')
    @team1 = @league.teams.create!(name: 'Test Team', strength: 55, teamable: @user)
    @team2 = @league.teams.create!(name: 'Test Team2', strength: 55, teamable: @user)
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

  it 'should be inactive as default' do
    league=League.create!(name:'inac League', level:2)
    expect(league.status).to eq ('inactive')
  end

  it 'can be set active' do
    league=League.create!(name:'inac League', level:2)
    league.update_attribute(:starts_at, Time.now)
    league.update_attribute(:league_length, 1)
    league.update_attribute(:pause_length, 1)

    league.teams.create!(name: 'Test Team', strength: 55, teamable: @user)
    league.teams.create!(name: 'Test Team2', strength: 55, teamable: @user)
    league.start
    expect(league.status).to eq ('active')
  end

  it 'cant be set active if attribute is missing' do
    league=League.create!(name:'inac League', level:2)
    league.update_attribute(:starts_at, Time.now)
    league.update_attribute(:league_length, 1)
    #league.update_attribute(:pause_length, 1)

    league.teams.create!(name: 'Test Team', strength: 55, teamable: @user)
    league.teams.create!(name: 'Test Team2', strength: 55, teamable: @user)
    league.start

    expect(league.status).to eq ('inactive')
  end

  it 'cant be set active if less than 2 teams' do
    league=League.create!(name:'inac League', level:2)
    league.update_attribute(:starts_at, Time.now)
    league.update_attribute(:league_length, 1)
    league.update_attribute(:pause_length, 1)

    #league.teams.create!(name: 'Test Team', strength: 55, teamable: @user)
    league.teams.create!(name: 'Test Team2', strength: 55, teamable: @user)
    league.start

    expect(league.status).to eq ('inactive')
  end

  it 'should have players through team' do
    expect(@league.players.count).to be > 0
  end

  it 'can schedule a match between two teamables' do
    user1 = Fabricate(:user, name:'User 1')
    user2 = Fabricate(:user, name: 'User 2')

    team1 = user1.teams.create(name: 'Team 1')
    team2 = user2.teams.create(name: 'Team 2')

    match = @league.schedule_match(team1, team2, 1.days.from_now)
    expect(match.teamA).to eq(team1)
    expect(match.teamB).to eq(team2)
    expect(match.status).to eq('scheduled')
  end
end
