import 'package:connect/Home/match.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';
import 'path.dart';

class Match {
  final Logger logger = Logger();
  Future<void> swipeResult(BuildContext context, String userId,
      String partnerId, String action) async {
    final url = ApiPath.swipeResult();

    try {
      logger.d(' $userId $partnerId $action');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer YOUR_AUTH_TOKEN',
        },
        body: jsonEncode({
          'id': userId,
          'other_id': partnerId,
          'action': action,
        }),
      );
      logger.d(response.body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        logger.d(responseData);

        if (responseData['status'] == 'success') {
          // Check if the response indicates a match
          final isMatch = responseData['match'] ?? false;
          final name = responseData['name'];

          if (isMatch) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MatchPage(matchName: name)));
          } else {
            logger.i('Successfully swiped $action for partner: $partnerId');
          }
        } else {
          logger.e('Failed to swipe: ${responseData['message']}');
        }
      } else {
        logger.e('Error: Received status code ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong. Please try again.')),
        );
      }
    } catch (e) {
      logger.e('Exception during swiping: $e, URL = $url');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred. Please try again later.')),
      );
    }
  }
}
