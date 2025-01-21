import 'package:connect/Backend/path.dart';
import 'package:connect/Providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../Model/profile.dart';

class Auth {
  static final Logger logger = Logger();

  Future<http.Response> login(
      BuildContext context, String phoneNumber, String pswd) async {
    final url = ApiPath.login();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone_no': phoneNumber,
          'password': pswd,
        }),
      );

      if (response.statusCode == 200) {
        logger.i('Login successful: ${response.body}');

        // Parse the profile details from the response
        final responseData = jsonDecode(response.body);

        // Assuming the profile details are in a "profile" key in the response JSON
        final profileData = responseData['profile'];

        // Update the ProfileProvider with the extracted profile details
        final profileProvider =
            Provider.of<ProfileProvider>(context, listen: false);
        profileProvider.setProfile(
          Profile(
            id: profileData['id'] as int?,
            name: profileData['name'] as String?,
            age: profileData['age'] as int?,
            gender: profileData['gender'] as String,
            phoneNo: profileData['phone_no'] as String?,
            about: profileData['about'] as String?,
            profilePicture: profileData['profile_picture'] as String?,
            pictures: (profileData['pictures'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [],
            interests: (profileData['interests'] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [],
          ),
        );
      } else {
        logger.w('Login failed: ${response.statusCode}, ${response.body}');
      }

      return response;
    } catch (e) {
      logger.e('Exception during login: $e, URL=$url');
      return http.Response('Exception: $e', 500);
    }
  }

  Future<http.Response> signup(Profile profile) async {
    final url = Uri.parse(ApiPath.signup());

    // Convert Profile object to JSON
    final Map<String, dynamic> body = profile.toJson();

    try {
      // Send POST request to the signup API endpoint
      final response = await http.post(
        url,
        headers: {
          'Content-Type':
              'application/json', // Set Content-Type to application/json
        },
        body: jsonEncode(body), // Convert Map to JSON string
      );

      if (response.statusCode == 200) {
        // Successfully signed up
        return response;
      } else {
        // Handle non-200 status codes (error case)
        logger.w('Signup failed: ${response.statusCode}, ${response.body}');
        return response;
      }
    } catch (e) {
      // Handle exceptions (e.g., network issues)
      logger.e('Exception during signup: $e');
      return http.Response(
          'Exception: $e', 500); // Return 500 error in case of exception
    }
  }
}
