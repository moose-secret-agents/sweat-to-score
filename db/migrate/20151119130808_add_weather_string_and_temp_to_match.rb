class AddWeatherStringAndTempToMatch < ActiveRecord::Migration
  def change
    add_column :matches, :temperature, :decimal, default: 20
    add_column :matches, :weather_string, :string
  end
end
