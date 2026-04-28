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
      final data = await _service.fetchWeather(position.latitude, position.longitude);
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

    // Reschedule if Rainy (logic from previous version)
    if (data.rainProbability > 60) {
      Get.find<RoutineController>().postponeWateringTasks();
    }

    // Cache the data
    _cacheWeather(data);
  }

  void _loadCachedWeather() {
    final cachedJson = _settingsBox.get('cached_weather_data');
    if (cachedJson != null) {
      try {
        // Assuming we store it as a Map or similar
        // For this demo, we'll just check if it exists and set loaded if we have data
        // If your WeatherModel has a fromMap/toMap, use it here.
        // weatherData.value = WeatherModel.fromMap(Map<String, dynamic>.from(cachedJson));
        // weatherState.value = 'loaded';
      } catch (e) {
        print('Error loading cached weather: $e');
      }
    }
  }

  void _cacheWeather(WeatherModel data) {
    // _settingsBox.put('cached_weather_data', data.toMap());
    _settingsBox.put('weather_last_update', DateTime.now().millisecondsSinceEpoch);
  }

  void retry() {
    _initWeather();
  }

  String getLottieFile() {
    if (weatherData.value == null) return 'weather_sunny.json';
    return _service.getLottieFile(weatherData.value!.conditionCode);
  }
}
