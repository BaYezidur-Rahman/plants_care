import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = '8d9047190d79639537d8e20cfd981882'; // Placeholder or User Key
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherModel> fetchWeather(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric&lang=bn'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }

  Future<WeatherModel> fetchWeatherByCity(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=bn'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data for city: $city');
      }
    } catch (e) {
      throw Exception('Error fetching weather by city: $e');
    }
  }

  String getLottieFile(int conditionCode) {
    final now = DateTime.now();
    final hour = now.hour;
    final isNight = hour >= 18 || hour < 6;

    if (isNight) return 'weather_night.json';
    
    if (conditionCode >= 200 && conditionCode <= 531) {
      return 'weather_rainy.json';
    } else if (conditionCode >= 600 && conditionCode <= 622) {
      return 'weather_cloudy.json';
    } else if (conditionCode == 800) {
      return 'weather_sunny.json';
    } else if (conditionCode >= 801 && conditionCode <= 804) {
      return 'weather_cloudy.json';
    }
    return 'weather_sunny.json';
  }

  WeatherAlert? getSmartAlert(WeatherModel weather) {
    if (weather.rainProbability > 60) {
      return WeatherAlert(
        message: "বৃষ্টির সম্ভাবনা আছে ☔ পানি দেওয়ার দরকার নেই",
        type: "info",
      );
    }
    if (weather.temp > 35) {
      return WeatherAlert(
        message: "তীব্র গরম 🌡️ সকালে ও সন্ধ্যায় পানি দিন",
        type: "warning",
      );
    }
    if (weather.windSpeed > 40) {
      return WeatherAlert(
        message: "ঝড়ের সম্ভাবনা 🌪️ ছাদের গাছ সরিয়ে নিন",
        type: "danger",
      );
    }
    if (weather.humidity < 30) {
      return WeatherAlert(
        message: "বাতাস শুষ্ক 💨 গাছে বাড়তি পানি দিন",
        type: "info",
      );
    }
    return null;
  }
}
