class WeatherFetcherSpec
  require 'rails_helper'
  RSpec.describe WeatherFetcher, type: :model do
    before(:each) do
      @weather_fetcher = WeatherFetcher.new
    end
    it "should get a number as temperature" do
      puts @weather_fetcher.fetch_temp
      expect{ @weather_fetcher.fetch_temp - 1.1 }.to_not raise_error
    end

  end
end