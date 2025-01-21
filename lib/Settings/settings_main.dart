import 'package:connect/Components/back.dart';
import 'package:connect/Login/login_main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/profile_provider.dart'; // Add this import for Provider

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    // Accessing the profile from the ProfileProvider
    final profile = Provider.of<ProfileProvider>(context).profile;

    // Check if profile is null to avoid crashes
    if (profile == null) {
      return Scaffold(
        appBar: AppBar(
          leading: const Back(),
        ),
        body: Center(
          child: Text(
            'Profile not found!',
            style: TextStyle(fontSize: 20, color: Colors.grey.shade700),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/pic.png', // Replace with actual profile image if available
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${profile.name} ${profile.age}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              profile.location!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to change password screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to notifications screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to help & support screen
              },
            ),
            const SizedBox(height: 30),
            // Sign Out Button
            ElevatedButton(
              onPressed: () {
                // Clear the profile and log out
                Provider.of<ProfileProvider>(context, listen: false)
                    .clearProfile();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLogin()),
                    (route) => false);
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red.shade900,
                backgroundColor: Colors.white38,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
