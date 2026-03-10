import 'package:flutter/material.dart';
import 'screens/weather_home.dart';

void main() {
  runApp(const WeatherCarApp());
}

class WeatherCarApp extends StatelessWidget {
  const WeatherCarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '车机天气',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      home: const WeatherHomeScreen(),
    );
  }
}
