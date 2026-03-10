import 'package:flutter/material.dart';
import '../models/weather_model.dart';

/// 天气预报卡片 - 显示在右侧
class ForecastCard extends StatelessWidget {
  final List<WeatherForecast> forecasts;

  const ForecastCard({super.key, required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Text(
                  '天气预报',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // 预报列表
            Expanded(
              child: ListView.separated(
                itemCount: forecasts.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.white.withOpacity(0.2),
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final forecast = forecasts[index];
                  return _buildForecastItem(forecast, index == 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastItem(WeatherForecast forecast, bool isToday) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          // 日期/星期
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? '今天' : forecast.weekDay,
                  style: TextStyle(
                    fontSize: isToday ? 18 : 16,
                    color: Colors.white,
                    fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                if (!isToday)
                  Text(
                    _formatDate(forecast.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white60,
                    ),
                  ),
              ],
            ),
          ),
          // 天气图标
          Expanded(
            child: Center(
              child: Icon(
                _getWeatherIcon(forecast.weatherType),
                size: 36,
                color: Colors.white,
              ),
            ),
          ),
          // 天气描述
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                forecast.weatherDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // 温度范围
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_upward, size: 16, color: Colors.red[300]),
                    const SizedBox(width: 4),
                    Text(
                      '${forecast.tempHigh.round()}°',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_downward, size: 16, color: Colors.blue[300]),
                    const SizedBox(width: 4),
                    Text(
                      '${forecast.tempLow.round()}°',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.month}/${date.day}';
    } catch (e) {
      return dateStr;
    }
  }
}
