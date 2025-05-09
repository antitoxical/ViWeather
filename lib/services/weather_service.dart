import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:viweather1/models/weather_model.dart';
import 'package:intl/intl.dart';


class WeatherService {
  final String apiKey = 'cd4e4233872b48bc96d190601250104';
  final String baseUrl = 'https://api.weatherapi.com/v1';

  Future<CurrentWeather> getCurrentWeather(String city) async {
    try {
      final url = '$baseUrl/forecast.json?key=$apiKey&q=$city&days=1&aqi=yes';
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CurrentWeather.fromJson(data);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error getting weather data: $e');
    }
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

  Future<CurrentWeatherDetails> getCurrentWeatherDetails(String city) async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=2'); // Запрашиваем 2 дня данных
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);

      // Парсинг времени восхода и заката
      final sunriseString = tryParseTime(data['forecast']['forecastday'][0]['astro']['sunrise']);
      final sunsetString = tryParseTime(data['forecast']['forecastday'][0]['astro']['sunset']);

      final sunrise = (sunriseString);
      final sunset = (sunsetString);

      if (sunrise == null || sunset == null) {
        throw Exception('Неверный формат времени восхода или заката');
      }

      // Получаем максимальную скорость ветра за сегодня
      final maxWindToday = data['forecast']['forecastday'][0]['day']['maxwind_kph'].toDouble();

      // Получаем максимальную скорость ветра за вчера (если есть данные)
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
    } else {
      print('API Error Response: ${response.body}');
      throw Exception('Ошибка получения данных: ${response.body}');
    }
  }

  Future<List<HourlyForecast>> getHourlyForecast(String city) async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=1');
    print('Request URL: $url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);
      print('API Response: $data');

      if (data['forecast'] == null || data['forecast']['forecastday'] == null) {
        throw Exception('Данные о прогнозе погоды отсутствуют');
      }

      return data['forecast']['forecastday'][0]['hour']
          .map<HourlyForecast>((hour) => HourlyForecast(
                time: hour['time'].split(' ')[1],
                temperature: hour['temp_c'].toDouble(),
                condition: hour['condition']['text'],
              ))
          .toList();
    } else {
      print('API Error Response: ${response.body}');
      throw Exception('Ошибка получения данных: ${response.body}');
    }
  }

  Future<List<DailyForecast>> getDailyForecast(String city) async {
    final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=5');
    print('Request URL: $url');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Явное декодирование тела ответа как UTF-8
      final decodedBody = utf8.decode(response.bodyBytes);
      final data = json.decode(decodedBody);
      print('API Response: $data');

      // Проверка наличия данных
      if (data['forecast'] == null || data['forecast']['forecastday'] == null) {
        throw Exception('Данные о прогнозе погоды отсутствуют');
      }

      return data['forecast']['forecastday']
          .map<DailyForecast>((day) => DailyForecast(
        day: day['date'],
        maxTemp: day['day']['maxtemp_c'].toDouble(),
        minTemp: day['day']['mintemp_c'].toDouble(),
        condition: day['day']['condition']['text'],
      ))
          .toList()
          .take(5)
          .toList();
    } else {
      print('API Error Response: ${response.body}');
      throw Exception('Ошибка получения данных: ${response.body}');
    }
  }

  Future<Map<String, double>> getCityCoordinates(String city) async {
    try {
      final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=1');
      print('Request URL for coordinates: $url');
      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Превышено время ожидания ответа от сервера');
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        print('Coordinates API Response: $data');

        if (data['location'] == null) {
          throw Exception('Данные о местоположении отсутствуют');
        }

        return {
          'latitude': data['location']['lat'],
          'longitude': data['location']['lon'],
        };
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Ошибка получения координат: ${response.body}');
      }
    } catch (e) {
      print('Error in getCityCoordinates: $e');
      rethrow;
    }
  }

  Future<int> getAirQuality(String city) async {
    try {
      final url = Uri.parse('$baseUrl/forecast.json?key=$apiKey&q=$city&days=1&aqi=yes');
      print('Request URL for AQI: $url');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);
        
        if (data['current'] == null || data['current']['air_quality'] == null) {
          throw Exception('Данные о качестве воздуха отсутствуют');
        }

        // Получаем US EPA индекс качества воздуха
        final usEpaIndex = data['current']['air_quality']['us-epa-index'];
        
        // Конвертируем US EPA индекс (1-6) в AQI (0-500)
        switch (usEpaIndex) {
          case 1: return 25;  // Хорошее (0-50)
          case 2: return 75;  // Умеренное (51-100)
          case 3: return 125; // Нездоровое для чувствительных групп (101-150)
          case 4: return 175; // Нездоровое (151-200)
          case 5: return 250; // Очень нездоровое (201-300)
          case 6: return 350; // Опасное (301-500)
          default: return 50; // По умолчанию возвращаем среднее значение "хорошего" качества
        }
      } else {
        print('API Error Response: ${response.body}');
        throw Exception('Ошибка получения данных о качестве воздуха: ${response.body}');
      }
    } catch (e) {
      print('Error in getAirQuality: $e');
      rethrow;
    }
  }
}