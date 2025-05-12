import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:translator/translator.dart';

class LocationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем, включена ли служба геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Служба геолокации отключена');
    }

    // Проверяем разрешения
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Разрешение на геолокацию отклонено');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Разрешение на геолокацию отклонено навсегда');
    }

    // Получаем текущее местоположение
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String?> _translateToEnglish(String text) async {
    try {
      // Проверяем, содержит ли текст только латинские буквы
      if (RegExp(r'^[a-zA-Z\s]+$').hasMatch(text)) {
        return text; // Если текст уже на английском, возвращаем как есть
      }

      final translation = await _translator.translate(
        text,
        from: 'auto', // Автоопределение языка
        to: 'en',
      );
      return translation.text;
    } catch (e) {
      print('Error translating text: $e');
      return text; // В случае ошибки возвращаем оригинальный текст
    }
  }

  Future<String?> getCityFromCoordinates(double lat, double lon, {bool translate = true}) async {
    try {
      final url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon');
      final response = await http.get(
        url,
        headers: {'User-Agent': 'ViWeather/1.0'},
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Превышено время ожидания ответа от сервера');
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'];
        
        // Пробуем получить название города из разных полей адреса
        String? cityName = address['city'] ?? 
                          address['town'] ?? 
                          address['village'] ?? 
                          address['municipality'] ??
                          address['county'];
        
        if (cityName != null) {
          if (translate) {
            // Переводим название города на английский
            final translatedName = await _translateToEnglish(cityName);
            return translatedName;
          } else {
            return cityName;
          }
        }
        
        // Если не нашли город, возвращаем координаты
        return '${lat.toStringAsFixed(2)}°N, ${lon.toStringAsFixed(2)}°E';
      } else {
        print('Error response from Nominatim: ${response.body}');
        return '${lat.toStringAsFixed(2)}°N, ${lon.toStringAsFixed(2)}°E';
      }
    } catch (e) {
      print('Error getting city name: $e');
      return '${lat.toStringAsFixed(2)}°N, ${lon.toStringAsFixed(2)}°E';
    }
  }
} 