
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:ui';  // Добавляем импорт для ImageFilter
import 'package:viweather1/models/weather_model.dart';
import 'package:viweather1/services/weather_service.dart';
import 'package:viweather1/services/location_service.dart';
import 'package:viweather1/widgets/temperature_chart.dart';
import 'package:viweather1/widgets/weather_map.dart';
import 'package:viweather1/cards/air_quality_card.dart';
import 'package:viweather1/widgets/animated_weather_icon.dart';
import 'package:viweather1/widgets/animated_weather_background.dart';
import '../cards/humidity_card.dart';
import '../cards/moonphase_card.dart';
import '../cards/precipitation_card.dart';
import '../cards/pressure_card.dart';
import '../cards/sunrise_card.dart';
import '../cards/wind_card.dart';
import 'package:viweather1/cards/clothing_recommendation_card.dart';
import 'package:flutter/rendering.dart';
import 'package:viweather1/widgets/weather_card_base.dart';



import '../theme/app_colors.dart';

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
        SnackBar(content: Text('Error getting location: $e')),
      );
    }
  }

  Future<void> fetchWeatherDataByCoordinates(double lat, double lon) async {
    try {
      final locationInfo = await _locationService.getCityFromCoordinates(lat, lon, translate: true);
      if (locationInfo.cityName.isNotEmpty) {
        _cityController.text = locationInfo.cityName;
        await fetchWeatherData(locationInfo.cityName);
      } else {
        throw Exception('Could not determine city name');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting weather data: $e')),
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
        SnackBar(content: Text('Error getting weather data: $e')),
      );
    }
  }


  Future<void> _handleMapLocationSelected(double lat, double lon, LocationInfo locationInfo) async {
    try {
      if (locationInfo.cityName.isNotEmpty) {
        _cityController.text = locationInfo.cityName;
        await fetchWeatherData(locationInfo.cityName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not determine city name for selected location')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error getting city name: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  bool _isDayTime() {
    if (currentWeather == null) return true;

    final now = DateTime.now();
    // Преобразуем строку timezone в число, убирая все нечисловые символы
    final timezoneStr = currentWeather!.timezone.replaceAll(RegExp(r'[^0-9-]'), '');
    final timezone = int.tryParse(timezoneStr) ?? 0;
    final localTime = now.add(Duration(hours: timezone));

    return localTime.hour >= 6 && localTime.hour < 20;
  }

  Widget _buildWeatherCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 0.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDay = _isDayTime();

    return Scaffold(
      body: Stack(
        children: [
          AnimatedWeatherBackground(
            weatherCondition: currentWeather?.condition ?? 'Clear',
            isDay: isDay,
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          decoration: InputDecoration(
                            labelText: 'Enter city name',
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.15),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
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
                              SnackBar(content: Text('Please enter a city name')),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white.withOpacity(0.2),
                        ),
                        child: Text('Search', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                Expanded(

                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (currentWeather != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        currentWeather!.location,
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 32,
                                          fontWeight: FontWeight.w300,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      if (currentWeather!.region != null && currentWeather!.country != null)
                                        Text(
                                          '${currentWeather!.region}, ${currentWeather!.country}',
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                    ],
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${currentWeather!.temperature.toStringAsFixed(0)}°',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 96,
                                      fontWeight: FontWeight.w200,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    currentWeather!.condition,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'H:${currentWeather!.maxTemp.toStringAsFixed(0)}° L:${currentWeather!.minTemp.toStringAsFixed(0)}°',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),



                                if (dailyForecast != null)
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: WeatherCardBase(
                                        condition: currentWeather?.condition ?? 'Clear',
                                        isDay: isDay,
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
                                                        '${forecast.maxTemp.toStringAsFixed(0)}°/${forecast.minTemp.toStringAsFixed(0)}°',
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
                                    ),
                                  ),

                                if (hourlyForecast != null && hourlyForecast!.length == 24)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: TemperatureChart(
                                      temperatures: hourlyForecast!.map((h) => h.temperature).toList(),
                                      timezone: currentWeather!.timezone,
                                      isDay: isDay,
                                      condition: currentWeather?.condition ?? 'Clear',
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
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(bottom: 16),
                                            child: AirQualityCard(
                                              aqi: airQualityIndex,
                                              description: 'Current air quality in your region',
                                              condition: currentWeather!.condition,
                                              isDay: isDay,
                                            ),
                                          ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: WindCard(
                                            windSpeed: currentWeatherDetails!.windSpeed,
                                            windGusts: currentWeatherDetails!.windGusts,
                                            windDirection: currentWeatherDetails!.windDirection,
                                            condition: currentWeather!.condition,
                                            maxDailyWind: currentWeatherDetails!.maxDailyWind,
                                            yesterdayMaxWind: currentWeatherDetails!.yesterdayMaxWind,
                                            isDay: isDay,
                                            hourlyData: hourlyForecast,
                                            timezone:currentWeather!.timezone,
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: HumidityCard(
                                            humidity: currentWeatherDetails!.humidity,
                                            dewPoint: currentWeatherDetails!.dewPoint,
                                            condition: currentWeather!.condition,
                                            isDay: isDay,
                                            hourlyData: hourlyForecast,
                                            timezone:currentWeather!.timezone,

                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: PressureCard(
                                            pressure: currentWeatherDetails!.pressure,
                                            condition: currentWeather!.condition,
                                            isDay: isDay,
                                            hourlyData: hourlyForecast,
                                            timezone:currentWeather!.timezone,
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: SunriseSunsetCard(
                                            sunrise: currentWeatherDetails!.sunrise,
                                            sunset: currentWeatherDetails!.sunset,
                                            condition: currentWeather!.condition,
                                            isDay: isDay,
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: MoonPhaseCard(
                                            moonIllumination: currentWeatherDetails!.moonIllumination,
                                            moonPhase: currentWeatherDetails!.moonPhase,
                                            condition: currentWeather!.condition,
                                            isDay: isDay,
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: PrecipitationCard(
                                            precipitation: currentWeatherDetails!.precipitation,
                                            description: currentWeatherDetails!.chanceOfRain,
                                            condition: currentWeather!.condition,
                                            isDay: isDay,
                                            hourlyData: hourlyForecast,
                                            timezone:currentWeather!.timezone,
                                          ),
                                        ),

                                        Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: ClothingRecommendationCard(
                                            temperature: currentWeather!.temperature,
                                            condition: currentWeather!.condition,
                                            isDay: isDay,
                                          ),
                                        ),

                                        Container(
                                          height: 200,
                                          width: double.infinity,
                                          margin: const EdgeInsets.only(bottom: 16),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: WeatherMap(
                                              latitude: cityCoordinates!['latitude']!,
                                              longitude: cityCoordinates!['longitude']!,
                                              onLocationSelected: _handleMapLocationSelected,
                                            ),
                                          ),
                                        ),
                                      ],
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
          ),
        ],
      ),
    );
  }
}