class WeatherFetcher
  URL = 'http://data.netcetera.com/smn/smn'

  def fetch_temp
    station = get_station
    station['temperature'].to_f
  end

  def fetch_precipitation
    station = get_station
    precipitation = station['precipitation'].to_f
    precipitation
  end

  def fetch_sunshine
    station = get_station
    sunshine = station['sunshine'].to_f
    sunshine
  end

  private
    def get_station
      stations = HTTParty.get(URL)
      stations.select{|station| station['station']['code'] == 'BER'}[0]
    end

end
