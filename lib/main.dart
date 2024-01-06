import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_api/screen/home_screen.dart';
import 'package:weather_app_api/screen/loading_screen.dart';
import 'package:weather_app_api/services/location_provider.dart';
import 'package:weather_app_api/services/weather_service_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => WeatherServiceProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
      ),
    );
  }
}
