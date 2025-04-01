class CurrentWeather {
  final String location;
  final double temperature;
  final String condition;
  final double maxTemp;
  final double minTemp;

  CurrentWeather({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.maxTemp,
    required this.minTemp,
  });
}

class HourlyForecast {
  final String time;
  final double temperature;
  final String condition;

  HourlyForecast({
    required this.time,
    required this.temperature,
    required this.condition,
  });
}

class DailyForecast {
  final String day;
  final double maxTemp;
  final double minTemp;
  final String condition;

  DailyForecast({
    required this.day,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
  });
}
class CurrentWeatherDetails {
  final double temperature;
  final double feelsLikeTemperature;
  final double precipitation;
  final double visibility;
  final double humidity;
  final double pressure;
  final double windSpeed;
  final double windGusts;
  final String windDirection;
  final double uvIndex;
  final DateTime sunrise;
  final DateTime sunset;
  final double moonIllumination;
  final String moonPhase;
  final double dewPoint;
  final double cloudCover;
  final int chanceOfRain;
  final int chanceOfSnow;

  CurrentWeatherDetails({
    required this.temperature,
    required this.feelsLikeTemperature,
    required this.precipitation,
    required this.visibility,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.windGusts,
    required this.windDirection,
    required this.uvIndex,
    required this.sunrise,
    required this.sunset,
    required this.moonIllumination,
    required this.moonPhase,
    required this.dewPoint,
    required this.cloudCover,
    required this.chanceOfRain,
    required this.chanceOfSnow,
  });
}