import 'package:location/location.dart';
import 'package:logger/logger.dart';
import '../Providers/location_provider.dart';

class LocationService {
  final Location location = Location();
  final LocationProvider locationProvider;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  LocationService(this.locationProvider);

  // Method to check if location service is enabled
  Future<void> checkService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  // Method to check and request location permission
  Future<void> checkPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  // Method to get the current location and update the provider
  Future<void> getCurrentLocation() async {
    await checkService();
    await checkPermission();

    try {
      _locationData = await location.getLocation();
      locationProvider.updateLocation(_locationData); // Update provider
    } catch (e) {
      Logger().e("Error retrieving location: $e");
    }
  }

  // Method to listen for location changes and update the provider
  void listenForLocationChanges() {
    location.onLocationChanged.listen((LocationData currentLocation) {
      locationProvider.updateLocation(currentLocation); // Update provider
    });
  }
}
