import 'dart:convert';
import 'package:connect/Backend/path.dart';
import 'package:connect/Providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../Model/profile.dart';

class ProfileApi {
  static final Logger logger = Logger();

  Future<List<Profile>> getProfiles(BuildContext context) async {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final Profile? profile = provider.profile;
    logger.d(profile);

    if (profile == null || profile.phoneNo == null) {
      throw Exception('Profile or phone number is not available.');
    }

    // Construct the URL with query parameters
    final url = Uri.parse('${ApiPath.getProfiles()}?phone_no=${profile.phoneNo}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse.containsKey('nearby_profiles')) {
          final List<dynamic> profilesJson = jsonResponse['nearby_profiles'];
          return profilesJson.map((json) => Profile.fromJson(json)).toList();
        } else {
          throw Exception('Unexpected response format: ${response.body}');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Profile not found: ${response.body}');
      } else {
        throw Exception('Failed to get profiles: ${response.body}');
      }
    } catch (e) {
      logger.e('Error getting profiles: $e');
      throw Exception('Error getting profiles: $e');
    }
  }
}
