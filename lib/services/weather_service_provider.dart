import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app_api/model/weather_model.dart';
import 'package:weather_app_api/secrets/api.dart';
import 'package:http/http.dart' as http;

class WeatherServiceProvider extends ChangeNotifier {
  WeatherModel? _weather;
  WeatherModel? get weather => _weather;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String _error = '';
  String get error => _error;
  TextEditingController searchController = TextEditingController();

  Future<void> fetchWeatherDataByCity(String city, context) async {
    _isLoading = true;
    _error = '';
    try {
      final String apiUrl =
          '${APIEndPoinds().cityUrl}${city}&appid=${APIEndPoinds().apiKey}${APIEndPoinds().units}';

      print(apiUrl);
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('$data');
        _weather = WeatherModel.fromJson(data);
        notifyListeners();
      } else {
        final snackBar = SnackBar(
            backgroundColor: Colors.red, content: Text("City not found"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        _error = 'Failed to load data';
        print(_error);
      }
    } catch (e) {
      _error = 'Error to load data$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
