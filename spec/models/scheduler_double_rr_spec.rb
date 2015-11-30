require 'rails_helper'

RSpec.describe SchedulerDoubleRR, type: :model do

  before(:each) do
    Team.delete_all
    User.delete_all
    Match.delete_all
    @league = League.create!(level: 2)
    @league.update_attribute(:league_length, 0)
    @league.update_attribute(:pause_length, 3)
    @league.update_attribute(:starts_at, Time.now-1.day)
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
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can schedule 3 teams' do
    (1..3).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can schedule 4 teams' do
    (1..4).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can schedule 5 teams' do
    (1..5).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can schedule 6 teams' do
    (1..6).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can schedule 7 teams' do
    (1..7).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can schedule 8 teams' do
    (1..8).each do
      add_team_to_league
    end
    schedule=@scheduler.schedule_season(@league)
    expect(@league.matches.length).to eq(@league.teams.length*(@league.teams.length-1))
    (1..(schedule.size-1)).each do |i|
      expect(schedule[i]).not_to be_empty
    end
  end

  it 'can split rounds with 3 teams during 7 days' do
    (1..3).each do
      add_team_to_league
    end
    league_length=7
    @league.update_attribute(:league_length, league_length)
    schedule=@scheduler.schedule_season(@league)


    (0..(schedule.size-1)).each do |i|
      expect(schedule[i].size).to eq(1) unless i==3
      expect(schedule[i].size).to eq(0) if i==3
    end
  end

  it 'can split rounds with 3 teams during 8 days' do
    (1..3).each do
      add_team_to_league
    end
    league_length=8
    @league.update_attribute(:league_length, league_length)
    schedule=@scheduler.schedule_season(@league)


    (0..(schedule.size-1)).each do |i|
      expect(schedule[i].size).to eq(1) unless [3,4].include?(i)
      expect(schedule[i].size).to eq(0) if [3,4].include?(i)
    end
  end

  it 'can distribute matches for 8 teams over 56 days' do
    (1..8).each do
      add_team_to_league
    end
    league_length=56
    @league.update_attribute(:league_length, league_length)
    schedule=@scheduler.schedule_season(@league)


    (0..(schedule.size-1)).each do |i|
      expect(schedule[i].size).to eq(1)
    end
  end

  it 'can distribute matches for 8 teams over 57 days' do
    (1..8).each do
      add_team_to_league
    end
    league_length=57
    @league.update_attribute(:league_length, league_length)
    schedule=@scheduler.schedule_season(@league)


    (0..(schedule.size-1)).each do |i|
      expect(schedule[i].size).to eq(1) unless i==28
      expect(schedule[i].size).to eq(0) if i==28
    end
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

  it 'should start overdue inactive league' do
    (1..2).each do
      add_team_to_league
    end

    starting_date=@league.reload.starts_at
    expect(@league.reload.status).to eq("inactive")
    SchedulingTasks.start_overdue_leagues
    next_starting_date=@league.reload.starts_at

    expect(@league.reload.status).to eq("active")
    expect(next_starting_date).to eq(starting_date+[@league.reload.league_length.day, 2.day].max+@league.reload.pause_length.day)
  end

  it 'should not start not overdue inactive league' do
    (1..2).each do
      add_team_to_league
    end
    @league.update_attribute(:starts_at, Time.now+1.day)

    expect(@league.reload.status).to eq("inactive")
    SchedulingTasks.start_overdue_leagues
    expect(@league.reload.status).to eq("inactive")
  end

  it 'should end finished active league' do
    (1..2).each do
      add_team_to_league
    end

    @league.start
    @league.reload.matches.each do |match|
      match.update_attribute(:status, Match.statuses[:ended])
    end

    expect(@league.reload.status).to eq("active")
    SchedulingTasks.end_finished_leagues
    expect(@league.reload.status).to eq("inactive")
  end

  it 'should not end unfinished active league' do
    (1..2).each do
      add_team_to_league
    end

    @league.start
    @league.reload.matches.first.update_attribute(:status, Match.statuses[:ended])

    expect(@league.reload.status).to eq("active")
    SchedulingTasks.end_finished_leagues
    expect(@league.reload.status).to eq("active")
  end
end
