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
      player.speed = 80
      player.stamina = 100
      player.fitness = 70
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
        player.fieldX = 1
        player.is_goalie = true
      else
        player.fieldX = -1
        player.fieldY = -1
      end
      player.save
    end
    i = 0
    playersB.each do |player|
      i+=1
      player.speed = 80
      player.stamina = 100
      player.fitness = 70
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
        player.fieldX = 1
        player.is_goalie = true
      else
        player.fieldX = -1
        player.fieldY = -1
      end
      player.save
    end
  end
  it 'throws exception if match is not scheduled' do
    @match.status = :started
    expect{@match.simulate}.to raise_error(Match::BadStateException)
  end

  it 'should be overcast when no sunshine and no precipitation' do
    mock_fetcher = double("weather_fetcher")
    allow(mock_fetcher).to receive_messages(
                       :fetch_temp => -1.0,
                       :fetch_precipitation => 0,
                       :fetch_sunshine => 0)

    @match.weather_fetcher = mock_fetcher

    expect( @match.compute_weather_string_and_temp[0] ).to eq 'overcast'
  end

  it 'should be moderate snowfall when no sunshine, under 0deg and little precipitation' do
    mock_fetcher = double("weather_fetcher")
    allow(mock_fetcher).to receive_messages(
                               :fetch_temp => -1.0,
                               :fetch_precipitation => 1,
                               :fetch_sunshine => 0)

    @match.weather_fetcher = mock_fetcher

    expect( @match.compute_weather_string_and_temp[0] ).to eq 'moderate snowfall'
  end

  it 'should be moderate rain when no sunshine, over 0deg and little precipitation' do
    mock_fetcher = double("weather_fetcher")
    allow(mock_fetcher).to receive_messages(
                               :fetch_temp => 1.0,
                               :fetch_precipitation => 1,
                               :fetch_sunshine => 0)

    @match.weather_fetcher = mock_fetcher

    expect( @match.compute_weather_string_and_temp[0] ).to eq 'moderate rain'
  end

  it 'should be moderate rain when sunshine, over 0deg and little precipitation' do
    mock_fetcher = double("weather_fetcher")
    allow(mock_fetcher).to receive_messages(
                               :fetch_temp => 1.0,
                               :fetch_precipitation => 1,
                               :fetch_sunshine => 5)

    @match.weather_fetcher = mock_fetcher

    expect( @match.compute_weather_string_and_temp[0] ).to eq 'moderate rain'
  end

  it 'should be sunny when sunshine and no precipitation' do
    mock_fetcher = double("weather_fetcher")
    allow(mock_fetcher).to receive_messages(
                               :fetch_temp => 18.0,
                               :fetch_precipitation => 0,
                               :fetch_sunshine => 10)

    @match.weather_fetcher = mock_fetcher

    expect( @match.compute_weather_string_and_temp[0] ).to eq 'clear'
  end

  it 'simulates match if match is scheduled' do

    #mock_fetcher = double("weather_fetcher")
    #allow(mock_fetcher).to receive_messages(
    #                           :fetch_temp => 18.0,
    #                           :fetch_precipitation => 0,
    #                           :fetch_sunshine => 10)

    #@match.weather_fetcher = mock_fetcher

    @match.status = :scheduled
    RubyProf.start
    @match.rand = Random.new#(115032730400174366788466674494640623226)
    expect{1.times do @match.simulate end}.to_not raise_error
    result = RubyProf.stop
    #printer = RubyProf::FlatPrinter.new(result)
    #printer.print(STDOUT)
  end
end
