require 'rails_helper'


RSpec.describe Match, type: :model do
  before(:each) do
    @match = Fabricate(:match)
    @match.save

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
