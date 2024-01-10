import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_api/model/weather_model.dart';
import 'package:weather_app_api/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  WeatherModel? weather;

  final WeatherService weatherService = WeatherService();
  Future<WeatherModel?> fetchWeatherDataByCity(city, context) async {
    isLoading = true;
    notifyListeners();
    try {
      weather = await weatherService.fetchWeatherDataByCity(city, context);
    } catch (e) {
      log('Exception occurred while fetching weather: $e');

      weather = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return weather;
  }

  searchCity(BuildContext context) async {
    await fetchWeatherDataByCity(searchController.text.trim(), context);
    searchController.clear();
    notifyListeners();
  }
}
