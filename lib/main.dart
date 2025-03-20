import 'package:connect/Login/login_main.dart';
import 'package:connect/Providers/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Backend/location.dart';
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

  ChatRoomProvider chatprovider = ChatRoomProvider();

  runApp(App(
      locationProvider: locationProvider,
      profileProvider: profileProvider,
      chatRoomProvider: chatprovider));
}

class App extends StatelessWidget {
  final ChatRoomProvider chatRoomProvider;
  final LocationProvider locationProvider;
  final ProfileProvider profileProvider;

  const App({
    super.key,
    required this.chatRoomProvider,
    required this.locationProvider,
    required this.profileProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatRoomProvider>.value(value: chatRoomProvider),
        ChangeNotifierProvider<LocationProvider>.value(value: locationProvider),
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: ThemeData(useMaterial3: true),
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
