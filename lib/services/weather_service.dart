import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viweather1/models/weather_model.dart';
import 'package:intl/intl.dart';



class WeatherService {
  final String apiKey = 'cd4e4233872b48bc96d190601250104';
  final String baseUrl = 'https://api.weatherapi.com/v1';

  // Объединенный метод для получения всех данных о погоде
  Future<Map<String, dynamic>> getAllWeatherData(String city) async {
    try {
      // Делаем один запрос с параметром days=5 для получения всех необходимых данных
      final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=5&aqi=yes');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Превышено время ожидания ответа от сервера');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Получаем все необходимые данные из одного ответа
        final current = CurrentWeather.fromJson(data);
        final coordinates = {
          'latitude': (data['location']['lat'] as num).toDouble(),
          'longitude': (data['location']['lon'] as num).toDouble(),
        };
        
        // Формируем почасовой прогноз
        final hourly = data['forecast']['forecastday'][0]['hour']
            .map<HourlyForecast>((hour) => HourlyForecast(
                  time: hour['time'].split(' ')[1],
                  temperature: hour['temp_c'].toDouble(),
                  condition: hour['condition']['text'],
                ))
            .toList();

        // Формируем ежедневный прогноз
        final daily = data['forecast']['forecastday']
            .map<DailyForecast>((day) => DailyForecast(
                  day: day['date'],
                  maxTemp: day['day']['maxtemp_c'].toDouble(),
                  minTemp: day['day']['mintemp_c'].toDouble(),
                  condition: day['day']['condition']['text'],
                ))
            .toList()
            .take(5)
            .toList();

        // Формируем детальную информацию
        final details = _parseWeatherDetails(data);
        
        // Получаем индекс качества воздуха
        final aqi = _parseAirQuality(data);

        return {
          'current': current,
          'coordinates': coordinates,
          'hourly': hourly,
          'daily': daily,
          'details': details,
          'aqi': aqi,
        };
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Ошибка получения данных: ${response.body}');
      }
    } catch (e) {
      print('Error in getAllWeatherData: $e');
      rethrow;
    }
  }

  CurrentWeatherDetails _parseWeatherDetails(Map<String, dynamic> data) {
    final sunrise = tryParseTime(data['forecast']['forecastday'][0]['astro']['sunrise']);
    final sunset = tryParseTime(data['forecast']['forecastday'][0]['astro']['sunset']);
    final maxWindToday = data['forecast']['forecastday'][0]['day']['maxwind_kph'].toDouble();
    double maxWindYesterday = 0.0;
    if (data['forecast']['forecastday'].length > 1) {
      maxWindYesterday = data['forecast']['forecastday'][1]['day']['maxwind_kph'].toDouble();
    }

    return CurrentWeatherDetails(
      temperature: data['current']['temp_c'].toDouble(),
      feelsLikeTemperature: data['current']['feelslike_c'].toDouble(),
      precipitation: data['forecast']['forecastday'][0]['day']['totalprecip_mm'].toDouble(),
      visibility: data['current']['vis_km'].toDouble(),
      humidity: data['current']['humidity'].toDouble(),
      pressure: data['current']['pressure_mb'].toDouble(),
      windSpeed: data['current']['wind_kph'].toDouble(),
      windGusts: data['current']['gust_kph'].toDouble(),
      windDirection: data['current']['wind_dir'],
      uvIndex: data['current']['uv'].toDouble(),
      sunrise: sunrise,
      sunset: sunset,
      moonIllumination: data['forecast']['forecastday'][0]['astro']['moon_illumination'].toDouble(),
      moonPhase: data['forecast']['forecastday'][0]['astro']['moon_phase'],
      dewPoint: data['current']['dewpoint_c'].toDouble(),
      cloudCover: data['current']['cloud'].toDouble(),
      chanceOfRain: data['forecast']['forecastday'][0]['day']['daily_chance_of_rain'] ?? 0,
      chanceOfSnow: data['forecast']['forecastday'][0]['day']['daily_chance_of_snow'] ?? 0,
      maxDailyWind: maxWindToday,
      yesterdayMaxWind: maxWindYesterday,
    );
  }

  int _parseAirQuality(Map<String, dynamic> data) {
    if (data['current'] == null || data['current']['air_quality'] == null) {
      return 50; // Значение по умолчанию
    }

    final usEpaIndex = data['current']['air_quality']['us-epa-index'];
    switch (usEpaIndex) {
      case 1: return 25;
      case 2: return 75;
      case 3: return 125;
      case 4: return 175;
      case 5: return 250;
      case 6: return 350;
      default: return 50;
    }
  }

  // Оставляем этот метод для обратной совместимости
  Future<CurrentWeather> getCurrentWeather(String city) async {
    final data = await getAllWeatherData(city);
    return data['current'] as CurrentWeather;
  }

  // Оставляем этот метод для обратной совместимости
  Future<Map<String, double>> getCityCoordinates(String city) async {
    final data = await getAllWeatherData(city);
    final coords = data['coordinates'] as Map<String, dynamic>;
    return {
      'latitude': (coords['latitude'] as num).toDouble(),
      'longitude': (coords['longitude'] as num).toDouble(),
    };
  }

  // Оставляем этот метод для обратной совместимости
  Future<List<HourlyForecast>> getHourlyForecast(String city) async {
    final data = await getAllWeatherData(city);
    return data['hourly'] as List<HourlyForecast>;
  }

  // Оставляем этот метод для обратной совместимости
  Future<List<DailyForecast>> getDailyForecast(String city) async {
    final data = await getAllWeatherData(city);
    return data['daily'] as List<DailyForecast>;
  }

  // Оставляем этот метод для обратной совместимости
  Future<CurrentWeatherDetails> getCurrentWeatherDetails(String city) async {
    final data = await getAllWeatherData(city);
    return data['details'] as CurrentWeatherDetails;
  }

  // Оставляем этот метод для обратной совместимости
  Future<int> getAirQuality(String city) async {
    final data = await getAllWeatherData(city);
    return data['aqi'] as int;
  }

  DateTime tryParseTime(String timeString) {
    // Разбиваем строку на часы, минуты и суффикс (AM/PM)
    final parts = timeString.split(RegExp(r'[:\s]'));
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = parts[2].toUpperCase(); // AM или PM

    // Преобразуем в 24-часовой формат
    int hour24 = hour;
    if (period == 'PM' && hour != 12) {
      hour24 += 12;
    } else if (period == 'AM' && hour == 12) {
      hour24 = 0;
    }

    // Создаем объект DateTime
    return DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour24, minute);
  }
}