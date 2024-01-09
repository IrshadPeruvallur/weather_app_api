import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_api/controller/weather_provider.dart';
import 'package:weather_app_api/services/location_service.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;
  final LocationService _locationService = LocationService();
  Placemark? _currentLocationName;
  Placemark? get currentLocationName => _currentLocationName;

  Future<void> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _currentPosition = null;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _currentPosition = null;
        notifyListeners();
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _currentPosition = null;
      notifyListeners();
      return;
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    print(_currentPosition);
    _currentLocationName =
        await _locationService.getLocationName(_currentPosition);
    print(_currentLocationName);
    notifyListeners();
  }

  void refreshCurrentLocationWeather(BuildContext context) async {
    final weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    // weatherProvider.isSearchClicked = true;

    final locationProvider =
        Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.determinePosition();

    if (locationProvider.currentLocationName != null) {
      var city = locationProvider.currentLocationName!.locality;
      if (city != null) {
        weatherProvider.fetchWeatherDataByCity(city, context);
        notifyListeners();
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Location Error"),
          content: Text(
              "Please ensure you have an internet connection and location services enabled."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        ),
      );
      notifyListeners();
    }
    final snackBar = SnackBar(content: Text("Refreshed for current city."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
