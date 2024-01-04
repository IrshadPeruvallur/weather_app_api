import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationService extends ChangeNotifier {
  Future<Placemark?> getLocationName(Position? position) async {
    if (position != null) {
      try {
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          return placemarks[0];
        }
      } catch (e) {
        print('Error fetching location Name');
      }
      return null;
    }
  }
}
