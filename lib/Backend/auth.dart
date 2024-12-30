import 'package:connect/Backend/path.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Model/profile.dart';

class Auth {
  static final Logger logger = Logger();

  Future<http.Response> login(String phoneNumber, String pswd) async {
    final url = ApiPath.login();

    try {
      final response = await http.post(
        Uri.parse(ApiPath.login()),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'phone': phoneNumber,
          'password': pswd,
        }),
      );

      if (response.statusCode == 200) {
        logger.i('Login successful: ${response.body}');
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
