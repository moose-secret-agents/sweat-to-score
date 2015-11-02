require 'rails_helper'

RSpec.describe SchedulerDoubleRR, type: :model do

  before(:each) do
    Team.delete_all
    User.delete_all
    Match.delete_all
    @league = League.create!(level: 2)
    @user = Fabricate(:user, username: 'User')
    @scheduler=SchedulerDoubleRR.new
  end

  def add_team_to_league
    Team.create!(name: 'just a team', strength: 50, league: @league, teamable: @user)
  end

  it 'cant schedule 0 teams' do
    (1..0).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
  end

  it 'cant schedule 1 teams' do
    (1..1).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
  end

  it 'schedule 2 teams' do
    (1..2).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 3 teams' do
    (1..3).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 4 teams' do
    (1..4).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 5 teams' do
    (1..5).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 6 teams' do
    (1..6).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 7 teams' do
    (1..7).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 8 teams' do
    (1..8).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'can schedule 8 teams' do
    (1..8).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'should schedule matches on league activation' do
    (1..4).each do
      add_team_to_league
    end
    @league.start
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
  end

  it 'should delete not played matches on league stop' do
    (1..4).each do
      add_team_to_league
    end
    @league.start
    @league.end
    expect(@league.reload.matches.length).to eq(0)
  end
end
