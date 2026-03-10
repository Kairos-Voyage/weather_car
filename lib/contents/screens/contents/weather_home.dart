import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/loading_weather.dart';

/// 天气主页 - 横屏车机界面
/// 左侧：当前位置 + 当前天气
/// 右侧：未来 3-5 天预报
class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  WeatherData? _weatherData;
  String? _errorMessage;
  bool _isLoading = true;
  String _city = '北京'; // 默认城市

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weather = await WeatherService.getWeatherByCity(_city);
      setState(() {
        _weatherData = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _showCitySelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择城市'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: '输入城市名称',
            prefixIcon: Icon(Icons.location_city),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _city = value;
              });
              _loadWeather();
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _loadWeather();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 车机通常横屏，强制横屏布局
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getBackgroundColors(),
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const LoadingWeather()
              : _errorMessage != null
                  ? _buildErrorView()
                  : _buildWeatherView(),
        ),
      ),
    );
  }

  List<Color> _getBackgroundColors() {
    if (_weatherData == null) {
      return [Colors.blue.shade400, Colors.blue.shade700];
    }

    final weatherType = _weatherData!.current.weatherType;
    switch (weatherType) {
      case 'sunny':
        return [Colors.orange.shade300, Colors.orange.shade600];
      case 'cloudy':
      case 'overcast':
      case 'few_clouds':
      case 'partly_cloudy':
        return [Colors.blueGrey.shade300, Colors.blueGrey.shade600];
      case 'rainy':
      case 'shower':
        return [Colors.blue.shade600, Colors.blue.shade900];
      case 'snowy':
        return [Colors.lightBlue.shade100, Colors.lightBlue.shade400];
      case 'thunderstorm':
        return [Colors.indigo.shade700, Colors.indigo.shade900];
      case 'fog':
      case 'haze':
        return [Colors.grey.shade400, Colors.grey.shade600];
      default:
        return [Colors.blue.shade400, Colors.blue.shade700];
    }
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.white70),
          const SizedBox(height: 16),
          Text(
            '获取天气数据失败',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? '未知错误',
            style: TextStyle(fontSize: 14, color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadWeather,
            icon: const Icon(Icons.refresh),
            label: const Text('重试'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherView() {
    return Column(
      children: [
        // 顶部栏
        _buildTopBar(),
        // 主要内容区
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 左侧：当前天气 (60% 宽度)
                Expanded(
                  flex: 6,
                  child: CurrentWeatherCard(
                    weather: _weatherData!.current,
                  ),
                ),
                const SizedBox(width: 24),
                // 右侧：天气预报 (40% 宽度)
                Expanded(
                  flex: 4,
                  child: ForecastCard(
                    forecasts: _weatherData!.forecasts,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                _weatherData!.current.city,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '最后更新：${_formatUpdateTime(_weatherData!.current.updateTime)}',
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.location_city, color: Colors.white),
                onPressed: _showCitySelector,
                tooltip: '切换城市',
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _loadWeather,
                tooltip: '刷新',
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatUpdateTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
