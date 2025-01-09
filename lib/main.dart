import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Backend/location.dart';
import 'Login/login_main.dart';
import 'Providers/location_provider.dart';
import 'Providers/profile_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create an instance of LocationProvider
  LocationProvider locationProvider = LocationProvider();

  // Create an instance of LocationService and pass the LocationProvider
  LocationService locationService = LocationService(locationProvider);

  // Fetch the current location
  await locationService.getCurrentLocation();

  // Listen for location changes
  locationService.listenForLocationChanges();

  // Create an instance of ProfileProvider
  ProfileProvider profileProvider = ProfileProvider();

  runApp(App(
    locationProvider: locationProvider,
    profileProvider: profileProvider,
  ));
}

class App extends StatelessWidget {
  final LocationProvider locationProvider;
  final ProfileProvider profileProvider;

  const App({
    super.key,
    required this.locationProvider,
    required this.profileProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocationProvider>.value(value: locationProvider),
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Connect',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainLogin(),
      ),
    );
  }
}
