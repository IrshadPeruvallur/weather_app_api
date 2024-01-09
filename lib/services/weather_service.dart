import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app_api/model/weather_model.dart';
import 'package:weather_app_api/secrets/api.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  Future<WeatherModel?> fetchWeatherDataByCity(String city, context) async {
    try {
      final String apiUrl =
          '${APIEndPoinds().cityUrl}${city}&appid=${APIEndPoinds().apiKey}${APIEndPoinds().units}';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        log('$data');
        return WeatherModel.fromJson(data);
      } else {
        final snackBar = SnackBar(
            backgroundColor: Colors.red, content: Text("City not found"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        log('Error:${response.statusCode}');
        return null;
      }
    } catch (e) {
      log('Exception:$e');
      return null;
    }
  }
}
