/// 当前天气数据模型
class CurrentWeather {
  final String city;
  final double temperature;
  final String weatherType;
  final String weatherDescription;
  final int humidity;
  final double windSpeed;
  final int airQuality;
  final DateTime updateTime;

  CurrentWeather({
    required this.city,
    required this.temperature,
    required this.weatherType,
    required this.weatherDescription,
    required this.humidity,
    required this.windSpeed,
    required this.airQuality,
    required this.updateTime,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      city: json['city'] ?? '未知城市',
      temperature: (json['temperature'] ?? 0).toDouble(),
      weatherType: json['weatherType'] ?? 'clear',
      weatherDescription: json['weatherDescription'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
      airQuality: json['airQuality'] ?? 0,
      updateTime: json['updateTime'] != null 
          ? DateTime.parse(json['updateTime']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'temperature': temperature,
      'weatherType': weatherType,
      'weatherDescription': weatherDescription,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'airQuality': airQuality,
      'updateTime': updateTime.toIso8601String(),
    };
  }
}

/// 天气预报数据模型
class WeatherForecast {
  final String date;
  final String weekDay;
  final double tempHigh;
  final double tempLow;
  final String weatherType;
  final String weatherDescription;
  final int humidity;
  final double windSpeed;

  WeatherForecast({
    required this.date,
    required this.weekDay,
    required this.tempHigh,
    required this.tempLow,
    required this.weatherType,
    required this.weatherDescription,
    required this.humidity,
    required this.windSpeed,
  });

  factory WeatherForecast.fromJson(Map<String, dynamic> json) {
    return WeatherForecast(
      date: json['date'] ?? '',
      weekDay: json['weekDay'] ?? '',
      tempHigh: (json['tempHigh'] ?? 0).toDouble(),
      tempLow: (json['tempLow'] ?? 0).toDouble(),
      weatherType: json['weatherType'] ?? 'clear',
      weatherDescription: json['weatherDescription'] ?? '',
      humidity: json['humidity'] ?? 0,
      windSpeed: (json['windSpeed'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weekDay': weekDay,
      'tempHigh': tempHigh,
      'tempLow': tempLow,
      'weatherType': weatherType,
      'weatherDescription': weatherDescription,
      'humidity': humidity,
      'windSpeed': windSpeed,
    };
  }
}

/// 完整天气数据
class WeatherData {
  final CurrentWeather current;
  final List<WeatherForecast> forecasts;

  WeatherData({
    required this.current,
    required this.forecasts,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: CurrentWeather.fromJson(json['current'] ?? {}),
      forecasts: (json['forecasts'] as List?)
              ?.map((e) => WeatherForecast.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'forecasts': forecasts.map((e) => e.toJson()).toList(),
    };
  }
}
