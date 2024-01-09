import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_api/controller/weather_provider.dart';
import 'package:weather_app_api/view/home_screen.dart';
import 'package:weather_app_api/view/loading_screen.dart';
import 'package:weather_app_api/controller/location_provider.dart';
import 'package:weather_app_api/services/weather_service.dart';

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
          create: (context) => WeatherProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoadingScreen(),
      ),
    );
  }
}
