import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:viweather1/models/weather_model.dart';
import 'package:viweather1/services/weather_service.dart';
import '../cards/humidity_card.dart';
import '../cards/moonphase_card.dart';
import '../cards/precipitation_card.dart';
import '../cards/pressure_card.dart';
import '../cards/sunrise_card.dart';
import '../cards/wind_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Создаем экземпляр WeatherService
  final WeatherService _weatherService = WeatherService();

  // Состояния для хранения данных погоды
  CurrentWeather? currentWeather;
  List<HourlyForecast>? hourlyForecast;
  List<DailyForecast>? dailyForecast;
  CurrentWeatherDetails? currentWeatherDetails;

  // Контроллер для текстового поля
  final TextEditingController _cityController = TextEditingController();

  Future<void> fetchWeatherData(String city) async {
    try {
      final current = await _weatherService.getCurrentWeather(city);
      final hourly = await _weatherService.getHourlyForecast(city);
      final daily = await _weatherService.getDailyForecast(city);
      final details = await _weatherService.getCurrentWeatherDetails(city);

      print('API Response for Daily Forecast: $daily'); // Добавьте эту строку

      setState(() {
        currentWeather = current;
        hourlyForecast = hourly;
        dailyForecast = daily;
        currentWeatherDetails = details;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Город не найден. Попробуйте снова.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData('Cupertino');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Градиентный фон
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade500,
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Поле ввода города
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                              labelText: 'Введите название города',
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final city = _cityController.text.trim();
                            if (city.isNotEmpty) {
                              fetchWeatherData(city);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Введите название города')),
                              );
                            }
                          },
                          child: Text('Поиск'),
                        ),
                      ],
                    ),
                  ),

                  // Отображение текущей погоды
                  if (currentWeather != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'MY LOCATION',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            currentWeather!.location,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${currentWeather!.temperature}°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            currentWeather!.condition,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            'H:${currentWeather!.maxTemp}° L:${currentWeather!.minTemp}°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Center(child: CircularProgressIndicator()),

                  // Часовой прогноз
                  if (hourlyForecast != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          const Text(
                            'Sunny conditions will continue all day. Wind gusts are up to 12 km/h.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: hourlyForecast!
                                  .map((hour) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      hour.time,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.sunny, // Здесь можно добавить иконки погоды
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '${hour.temperature}°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                                  .toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (dailyForecast != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DAILY FORECAST',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true, // Уменьшает размер до содержимого
                            physics: NeverScrollableScrollPhysics(), // Отключает прокрутку
                            itemCount: dailyForecast!.length,
                            itemBuilder: (context, index) {
                              final forecast = dailyForecast![index];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // День недели с иконкой погоды
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.sunny, // Здесь можно добавить иконки погоды
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8), // Отступ между иконкой и текстом
                                      Text(
                                        DateFormat.E().format(DateTime.parse(forecast.day)),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Информация о погоде (максимальная и минимальная температура)
                                  Row(
                                    children: [
                                      Text(
                                        '${forecast.maxTemp}°/${forecast.minTemp}°',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                  // Детальная информация (карточки)
                  if (currentWeatherDetails != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DETAILED INFORMATION',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          WindCard(
                            windSpeed: currentWeatherDetails!.windSpeed,
                            windGusts: currentWeatherDetails!.windGusts,
                            windDirection: currentWeatherDetails!.windDirection,
                          ),
                          SizedBox(height: 16),
                          HumidityCard(
                            humidity: currentWeatherDetails!.humidity,
                            dewPoint: currentWeatherDetails!.dewPoint,
                          ),
                          SizedBox(height: 16),
                          PressureCard(
                            pressure: currentWeatherDetails!.pressure,
                          ),
                          SizedBox(height: 16),
                          SunriseSunsetCard(
                            sunrise: currentWeatherDetails!.sunrise,
                            sunset: currentWeatherDetails!.sunset,
                          ),
                          SizedBox(height: 16),
                          MoonPhaseCard(
                            moonIllumination: currentWeatherDetails!.moonIllumination,
                            moonPhase: currentWeatherDetails!.moonPhase,
                          ),
                          SizedBox(height: 16),
                          PrecipitationCard(
                            precipitation: currentWeatherDetails!.precipitation,
                            description: 'Следующий снегопад ожидается в воскресенье и составит 12 мм.',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}