import 'dart:convert';
import 'package:connect/Backend/path.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import '../Providers/profile_provider.dart';

class ChatService {
  IOWebSocketChannel? channel;
  Logger logger = Logger();

  void connect(int chatRoomId) {
    try {
      channel =
          IOWebSocketChannel.connect('ws://10.0.2.2:8000/ws/chat/$chatRoomId/');
      logger.i("Connected to WebSocket: Chat Room $chatRoomId");
    } catch (e) {
      logger.e("WebSocket connection failed: $e");
    }
  }

  void disconnect() {
    try {
      channel?.sink.close();
      logger.i("WebSocket disconnected");
    } catch (e) {
      logger.e("Error closing WebSocket: $e");
    }
  }

  void sendMessage(String message, String senderId, String receiverId) {
    if (channel != null) {
      channel!.sink.add(jsonEncode({
        'message': message,
        'receiverId': receiverId,
        'senderId': senderId,
      }));
    } else {
      logger.e("WebSocket is not connected!");
    }
  }

  void updateTypingStatus(String senderId, String receiverId, bool isTyping) {
    if (channel != null) {
      channel!.sink.add(jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'isTyping': isTyping
      }));
    }
  }

  void updateMessageAsRead(String senderId, String receiverId) {
    if (channel != null) {
      channel!.sink.add(jsonEncode(
          {'receiverId': receiverId, 'senderId': senderId, 'read': true}));
    }
  }

  Future<List<Map<String, dynamic>>?> fetchChatRooms(int userId) async {
    final String url = ApiPath.chatRooms(userId);
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else {
        logger.e("Error: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      logger.e("Exception: $e");
      return null;
    }
  }

  Future<int?> createChatRoom(BuildContext context, int participant2) async {
    final String url = ApiPath.createChatRooms();

    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final int? participant1 = provider.profile?.id;

    if (participant1 == null) {
      logger.e("Error: Current user ID not found");
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'participant1': participant1,
          'participant2': participant2,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        int chatRoomId = data['chatRoomId'];
        logger.i("Chat room created: ID $chatRoomId");
        return chatRoomId;
      } else {
        logger.e(
            "Failed to create chat room: ${response.statusCode}, ${response.body}");
        return null;
      }
    } catch (e) {
      logger.e("Exception: $e");
      return null;
    }
  }
}
