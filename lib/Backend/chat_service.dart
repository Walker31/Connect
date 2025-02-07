import 'dart:convert';

import 'package:web_socket_channel/io.dart';

class ChatService {
  late IOWebSocketChannel channel;

  void connect(String roomName) {
    channel =
        IOWebSocketChannel.connect('ws://10.0.2.2:8000/ws/chat/$roomName/');
  }

  void sendMessage(String message, String senderId, String receiverId) {
    channel.sink.add(jsonEncode({
      'message': message,
      'receiverId': receiverId,
      'senderId': senderId,
    }));
  }

  void updateTypingStatus(String senderId, String receiverId, bool isTyping) {
    channel.sink.add(jsonEncode({
      'senderId': senderId,
      'receiverId': receiverId,
      'isTyping': isTyping
    }));
  }

  void updateMessageAsRead(String senderId, String receiverId) {
    channel.sink.add(jsonEncode(
        {'receiverId': receiverId, 'senderId': senderId, 'read': true}));
  }
}
