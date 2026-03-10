import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

/// 天气服务 - 支持多个天气 API
class WeatherService {
  // 和风天气 API (推荐 - 国内更准确)
  // 注册：https://dev.qweather.com/
  static const String _qweatherKey = 'YOUR_QWEATHER_KEY';
  static const String _qweatherUrl = 'https://devapi.qweather.com/v7';
  
  // OpenWeatherMap API (备选)
  // 注册：https://openweathermap.org/api
  static const String _openWeatherKey = 'YOUR_OPENWEATHER_KEY';
  static const String _openWeatherUrl = 'https://api.openweathermap.org/data/2.5';

  /// 获取当前天气和预报 (使用和风天气)
  static Future<WeatherData> getWeatherByCity(String city) async {
    try {
      // 1. 先获取城市 ID
      final locationResponse = await http.get(
        Uri.parse('$_qweatherUrl/geo/cities?location=$city&key=$_qweatherKey'),
      );
      
      if (locationResponse.statusCode != 200) {
        throw Exception('获取城市信息失败');
      }
      
      final locationData = json.decode(locationResponse.body);
      if (locationData['code'] != '200' || locationData['location'].isEmpty) {
        throw Exception('未找到城市：$city');
      }
      
      final locationId = locationData['location'][0]['id'];
      final cityName = locationData['location'][0]['name'];
      
      // 2. 获取当前天气
      final weatherResponse = await http.get(
        Uri.parse('$_qweatherUrl/weather/now?location=$locationId&key=$_qweatherKey'),
      );
      
      // 3. 获取天气预报
      final forecastResponse = await http.get(
        Uri.parse('$_qweatherUrl/weather/3d?location=$locationId&key=$_qweatherKey'),
      );
      
      if (weatherResponse.statusCode != 200 || forecastResponse.statusCode != 200) {
        throw Exception('获取天气数据失败');
      }
      
      final weatherData = json.decode(weatherResponse.body);
      final forecastData = json.decode(forecastResponse.body);
      
      final now = weatherData['now'];
      final forecasts = forecastData['daily'];
      
      // 构建当前天气
      final current = CurrentWeather(
        city: cityName,
        temperature: double.tryParse(now['temp'] ?? '0') ?? 0,
        weatherType: _mapWeatherIcon(now['icon'] ?? '100'),
        weatherDescription: _mapWeatherDesc(now['text'] ?? ''),
        humidity: int.tryParse(now['humidity'] ?? '0') ?? 0,
        windSpeed: double.tryParse(now['windSpeed'] ?? '0') ?? 0,
        airQuality: 50, // 需要额外 API 获取
        updateTime: DateTime.now(),
      );
      
      // 构建天气预报
      final forecastList = <WeatherForecast>[];
      final weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
      
      for (var i = 0; i < forecasts.length && i < 5; i++) {
        final day = forecasts[i];
        final date = DateTime.parse(day['fxDate']);
        forecastList.add(WeatherForecast(
          date: day['fxDate'],
          weekDay: i == 0 ? '今天' : weekDays[date.weekday % 7],
          tempHigh: double.tryParse(day['tempMax'] ?? '0') ?? 0,
          tempLow: double.tryParse(day['tempMin'] ?? '0') ?? 0,
          weatherType: _mapWeatherIcon(day['iconDay'] ?? '100'),
          weatherDescription: _mapWeatherDesc(day['textDay'] ?? ''),
          humidity: int.tryParse(day['humidity'] ?? '0') ?? 0,
          windSpeed: double.tryParse(day['windSpeedDay'] ?? '0') ?? 0,
        ));
      }
      
      return WeatherData(current: current, forecasts: forecastList);
    } catch (e) {
      // 如果和风天气失败，返回模拟数据用于测试
      return _getMockWeatherData(city);
    }
  }
  
  /// 根据经纬度获取天气
  static Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    // 类似实现，使用经纬度查询
    return getWeatherByCity('北京'); // 临时返回城市查询
  }
  
  /// 和风天气图标映射
  static String _mapWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '100': return 'sunny';
      case '101': return 'cloudy';
      case '102': return 'few_clouds';
      case '103': return 'partly_cloudy';
      case '104': return 'overcast';
      case '150':
      case '151':
      case '152': return 'fog';
      case '300':
      case '301':
      case '302': return 'shower';
      case '303':
      case '304':
      case '305':
      case '306':
      case '307':
      case '308':
      case '309':
      case '310':
      case '311':
      case '312':
      case '313':
      case '314':
      case '315':
      case '316':
      case '317':
      case '318':
      case '350':
      case '351':
      case '399': return 'rainy';
      case '400':
      case '401':
      case '402':
      case '403':
      case '404':
      case '405':
      case '406':
      case '407':
      case '408':
      case '409':
      case '410':
      case '456':
      case '457':
      case '499': return 'snowy';
      case '500':
      case '501':
      case '502':
      case '503':
      case '504':
      case '507':
      case '508':
      case '509':
      case '510':
      case '511':
      case '512':
      case '513':
      case '514':
      case '515':
      case '521':
      case '522':
      case '523':
      case '524':
      case '850':
      case '851':
      case '852':
      case '853':
      case '854':
      case '855':
      case '856':
      case '857':
      case '858':
      case '859':
      case '860':
      case '861':
      case '862':
      case '863':
      case '864':
      case '865':
      case '866':
      case '867':
      case '868':
      case '869':
      case '870':
      case '871':
      case '872':
      case '873':
      case '874':
      case '875':
      case '876':
      case '877':
      case '878':
      case '879':
      case '880':
      case '881':
      case '882':
      case '883':
      case '884':
      case '885':
      case '886':
      case '887':
      case '888':
      case '889':
      case '890':
      case '891':
      case '892':
      case '893':
      case '894':
      case '895':
      case '896':
      case '897':
      case '898':
      case '899':
      case '900':
      case '901':
      case '999': return 'thunderstorm';
      case '1300':
      case '1301':
      case '1302': return 'haze';
      default: return 'sunny';
    }
  }
  
  /// 天气描述映射
  static String _mapWeatherDesc(String desc) {
    return desc;
  }
  
  /// 获取模拟数据（用于测试或 API 不可用时）
  static WeatherData _getMockWeatherData(String city) {
    final now = DateTime.now();
    final weekDays = ['周日', '周一', '周二', '周三', '周四', '周五', '周六'];
    
    return WeatherData(
      current: CurrentWeather(
        city: city,
        temperature: 22,
        weatherType: 'sunny',
        weatherDescription: '晴朗',
        humidity: 65,
        windSpeed: 3.2,
        airQuality: 45,
        updateTime: now,
      ),
      forecasts: List.generate(5, (index) {
        final date = now.add(Duration(days: index));
        return WeatherForecast(
          date: '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
          weekDay: index == 0 ? '今天' : weekDays[date.weekday % 7],
          tempHigh: 25 - index * 2,
          tempLow: 18 - index,
          weatherType: ['sunny', 'cloudy', 'partly_cloudy', 'rainy', 'sunny'][index],
          weatherDescription: ['晴朗', '多云', '晴间多云', '小雨', '晴朗'][index],
          humidity: 60 + index * 5,
          windSpeed: 2.5 + index * 0.5,
        );
      }),
    );
  }
}
