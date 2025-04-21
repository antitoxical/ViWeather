import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:viweather1/models/weather_model.dart';
import 'package:viweather1/services/weather_service.dart';
import 'package:viweather1/services/location_service.dart';
import 'package:viweather1/widgets/temperature_chart.dart';
import 'package:viweather1/widgets/weather_map.dart';
import 'package:viweather1/widgets/air_quality_card.dart';
import 'package:viweather1/widgets/animated_weather_icon.dart';
import '../cards/humidity_card.dart';
import '../cards/moonphase_card.dart';
import '../cards/precipitation_card.dart';
import '../cards/pressure_card.dart';
import '../cards/sunrise_card.dart';
import '../cards/wind_card.dart';
import 'package:viweather1/widgets/clothing_recommendation_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  bool _isLoading = true;

  CurrentWeather? currentWeather;
  List<HourlyForecast>? hourlyForecast;
  List<DailyForecast>? dailyForecast;
  CurrentWeatherDetails? currentWeatherDetails;
  Position? currentPosition;
  Map<String, double>? cityCoordinates;
  int airQualityIndex = 0;

  final TextEditingController _cityController = TextEditingController();

  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      setState(() {
        currentPosition = position;
        cityCoordinates = {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
      });
      await fetchWeatherDataByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка получения местоположения: $e')),
      );
    }
  }

  Future<void> fetchWeatherDataByCoordinates(double lat, double lon) async {
    try {
      final city = await _locationService.getCityFromCoordinates(lat, lon);
      await fetchWeatherData(city);
    } catch (e) {
      print('Error fetching weather data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка получения данных о погоде: $e')),
      );
    }
  }

  Future<void> fetchWeatherData(String city) async {
    try {
      setState(() => _isLoading = true);
      
      // Получаем координаты города
      final coordinates = await _weatherService.getCityCoordinates(city);
      setState(() => cityCoordinates = coordinates);

      final current = await _weatherService.getCurrentWeather(city);
      final hourly = await _weatherService.getHourlyForecast(city);
      final daily = await _weatherService.getDailyForecast(city);
      final details = await _weatherService.getCurrentWeatherDetails(city);
      final aqi = await _weatherService.getAirQuality(city);

      setState(() {
        currentWeather = current;
        hourlyForecast = hourly;
        dailyForecast = daily;
        currentWeatherDetails = details;
        airQualityIndex = aqi;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Город не найден. Попробуйте снова.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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

                  if (currentWeather != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
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
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedWeatherIcon(
                                condition: currentWeather!.condition,
                                size: 80,
                              ),
                              Text(
                                '${currentWeather!.temperature}°',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 64,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
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
                  else if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    const Center(child: Text('Введите название города')),

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
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: dailyForecast!.length,
                            itemBuilder: (context, index) {
                              final forecast = dailyForecast![index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        AnimatedWeatherIcon(
                                          condition: forecast.condition,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          DateFormat.E().format(DateTime.parse(forecast.day)),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${forecast.maxTemp}°/${forecast.minTemp}°',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

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
                          const SizedBox(height: 16),

                          if (cityCoordinates != null)
                            Container(
                              height: 200,
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: WeatherMap(
                                  latitude: cityCoordinates!['latitude']!,
                                  longitude: cityCoordinates!['longitude']!,
                                ),
                              ),
                            ),

                          if (hourlyForecast != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: TemperatureChart(
                                temperatures: hourlyForecast!.map((forecast) => forecast.temperature).toList(),
                                timezone: currentWeather!.timezone,
                              ),
                            ),

                          if (currentWeather != null)
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: AirQualityCard(
                                aqi: airQualityIndex,
                                description: 'Текущее качество воздуха в вашем регионе',
                              ),
                            ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: WindCard(
                              windSpeed: currentWeatherDetails!.windSpeed,
                              windGusts: currentWeatherDetails!.windGusts,
                              windDirection: currentWeatherDetails!.windDirection,
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: HumidityCard(
                              humidity: currentWeatherDetails!.humidity,
                              dewPoint: currentWeatherDetails!.dewPoint,
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: PressureCard(
                              pressure: currentWeatherDetails!.pressure,
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: SunriseSunsetCard(
                              sunrise: currentWeatherDetails!.sunrise,
                              sunset: currentWeatherDetails!.sunset,
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: MoonPhaseCard(
                              moonIllumination: currentWeatherDetails!.moonIllumination,
                              moonPhase: currentWeatherDetails!.moonPhase,
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: PrecipitationCard(
                              precipitation: currentWeatherDetails!.precipitation,
                              description: 'Следующий снегопад ожидается в воскресенье и составит 12 мм.',
                            ),
                          ),

                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ClothingRecommendationCard(
                              temperature: currentWeather!.temperature,
                              condition: currentWeather!.condition,
                            ),
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