class WeatherModel {
  final String city;
  final double temp;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String condition;
  final int conditionCode;
  final String icon;
  final int rainProbability;

  WeatherModel({
    required this.city,
    required this.temp,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.conditionCode,
    required this.icon,
    this.rainProbability = 0,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      city: json['name'],
      temp: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      condition: json['weather'][0]['description'],
      conditionCode: json['weather'][0]['id'],
      icon: json['weather'][0]['icon'],
      // OpenWeatherMap current API doesn't provide rainProbability directly in basic call,
      // usually it's in 'rain' or 'pop' if using One Call API. 
      // We'll set it to 0 or extract if available.
      rainProbability: json['rain'] != null ? 70 : 0, 
    );
  }
}

class WeatherAlert {
  final String message;
  final String type; // info, warning, danger

  WeatherAlert({required this.message, required this.type});
}
