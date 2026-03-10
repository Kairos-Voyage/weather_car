import 'package:flutter/material.dart';
import '../models/weather_model.dart';

/// 当前天气卡片 - 显示在左侧
class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weather;

  const CurrentWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 城市名称
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.white70, size: 24),
                const SizedBox(width: 8),
                Text(
                  weather.city,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // 温度和天气图标
            Expanded(
              child: Row(
                children: [
                  // 天气图标
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _getWeatherIcon(weather.weatherType),
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // 温度
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${weather.temperature.round()}',
                        style: TextStyle(
                          fontSize: 96,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          height: 1,
                        ),
                      ),
                      Text(
                        '°C',
                        style: TextStyle(
                          fontSize: 48,
                          color: Colors.white70,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // 天气描述
            Text(
              weather.weatherDescription,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            // 详细信息
            _buildInfoRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      children: [
        _buildInfoItem(
          icon: Icons.water_drop,
          label: '湿度',
          value: '${weather.humidity}%',
        ),
          const SizedBox(width: 32),
        _buildInfoItem(
          icon: Icons.air,
          label: '风速',
          value: '${weather.windSpeed.toStringAsFixed(1)} km/h',
        ),
        const SizedBox(width: 32),
        _buildInfoItem(
          icon: Icons.blur_on,
          label: '空气质量',
          value: _getAirQualityLevel(weather.airQuality),
        ),
      ],
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.white60),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  IconData _getWeatherIcon(String weatherType) {
    switch (weatherType) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'few_clouds':
        return Icons.partly_cloudy_day;
      case 'partly_cloudy':
        return Icons.partly_cloudy_day;
      case 'overcast':
        return Icons.cloud_queue;
      case 'rainy':
      case 'shower':
        return Icons.grain;
      case 'snowy':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.thunderstorm;
      case 'fog':
      case 'haze':
        return Icons.foggy;
      default:
        return Icons.wb_sunny;
    }
  }

  String _getAirQualityLevel(int aqi) {
    if (aqi <= 50) return '优';
    if (aqi <= 100) return '良';
    if (aqi <= 150) return '轻度污染';
    if (aqi <= 200) return '中度污染';
    return '重度污染';
  }
}
