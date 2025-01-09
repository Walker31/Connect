import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';

class LocationProvider with ChangeNotifier {
  LocationData? _currentLocation;
  Logger logger = Logger();

  LocationData? get currentLocation => _currentLocation;

  void updateLocation(LocationData locationData) {
    _currentLocation = locationData;
    logger.d("Updated Location: Latitude = ${locationData.latitude}, Longitude = ${locationData.longitude}");
    notifyListeners(); // Notify listeners about the update
  }
}
