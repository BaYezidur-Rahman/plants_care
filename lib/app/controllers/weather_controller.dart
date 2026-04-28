// ignore_for_file: avoid_print, unnecessary_cast

import 'dart:async';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import '../data/models/weather_model.dart';
import '../data/services/weather_service.dart';
import '../utils/hive_boxes.dart';
import 'routine_controller.dart';

class WeatherController extends GetxController {
  final WeatherService _service = WeatherService();
  late Box _settingsBox;

  final weatherData = Rx<WeatherModel?>(null);
  final weatherState = 'loading'.obs; // loading, loaded, error
  final smartAlert = Rx<WeatherAlert?>(null);

  @override
  void onInit() {
    super.onInit();
    _settingsBox = Hive.box(HiveBoxes.settings);

    // Pattern: Never call async directly in onInit
    Future.delayed(Duration.zero, () async {
      await _initWeather();
    });
  }

  Future<void> _initWeather() async {
    try {
      weatherState.value = 'loading';

      // 1. Load cached weather first to show something to the user
      _loadCachedWeather();

      // 2. Check Permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        // Fallback to city if permission is denied
        await _fetchWeatherByCity();
        return;
      }

      // 3. Get Position with Timeout
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException('GPS Timeout'),
      );

      // 4. Fetch Weather by Coordinates
      final data =
          await _service.fetchWeather(position.latitude, position.longitude);
      _updateWeatherUI(data);
    } on TimeoutException {
      print('⚠️ GPS Timeout, trying city fallback');
      await _fetchWeatherByCity();
    } catch (e) {
      print('❌ Weather error: $e');
      if (weatherData.value == null) {
        weatherState.value = 'error';
      }
    }
  }

  Future<void> _fetchWeatherByCity() async {
    try {
      final city = _settingsBox.get('userCity', defaultValue: 'Dhaka');
      final data = await _service.fetchWeatherByCity(city);
      _updateWeatherUI(data);
    } catch (e) {
      print('❌ City weather error: $e');
      if (weatherData.value == null) {
        weatherState.value = 'error';
      }
    }
  }

  void _updateWeatherUI(WeatherModel data) {
    weatherData.value = data;
    smartAlert.value = _service.getSmartAlert(data);
    weatherState.value = 'loaded';

    // Safe: use try/catch and check if controller exists
    if (data.rainProbability > 60) {
      try {
        if (Get.isRegistered<RoutineController>()) {
          Get.find<RoutineController>().postponeWateringTasks();
        }
      } catch (e) {
        print('⚠️ Could not postpone watering: $e');
      }
    }

    // Cache the data
    _cacheWeather(data);
  }

  void _loadCachedWeather() {
    try {
      final temp = _settingsBox.get('cache_temp');
      final city = _settingsBox.get('cache_city');
      final condition = _settingsBox.get('cache_condition');
      final conditionCode = _settingsBox.get('cache_conditionCode');
      final humidity = _settingsBox.get('cache_humidity');
      final windSpeed = _settingsBox.get('cache_windSpeed');
      final icon = _settingsBox.get('cache_icon');

      if (temp != null && city != null) {
        weatherData.value = WeatherModel(
          city: city,
          temp: (temp as num).toDouble(),
          feelsLike: (temp as num).toDouble(),
          humidity: (humidity ?? 0) as int,
          windSpeed: (windSpeed ?? 0.0) as double,
          condition: condition ?? 'Clear',
          conditionCode: (conditionCode ?? 800) as int,
          icon: icon ?? '01d',
          rainProbability: 0,
        );
        weatherState.value = 'loaded';
        print('✅ Loaded cached weather for: $city');
      }
    } catch (e) {
      print('⚠️ Cache read error (non-fatal): $e');
    }
  }

  void _cacheWeather(WeatherModel data) {
    try {
      _settingsBox.put('cache_temp', data.temp);
      _settingsBox.put('cache_city', data.city);
      _settingsBox.put('cache_condition', data.condition);
      _settingsBox.put('cache_conditionCode', data.conditionCode);
      _settingsBox.put('cache_humidity', data.humidity);
      _settingsBox.put('cache_windSpeed', data.windSpeed);
      _settingsBox.put('cache_icon', data.icon);
      _settingsBox.put(
          'weather_last_update', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('⚠️ Cache write error (non-fatal): $e');
    }
  }

  void retry() {
    _initWeather();
  }

  String getLottieFile() {
    if (weatherData.value == null) return 'weather_sunny.json';
    return _service.getLottieFile(weatherData.value!.conditionCode);
  }
}
