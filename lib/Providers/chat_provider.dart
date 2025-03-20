import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../Backend/chat_service.dart';
import '../Model/chat_room.dart';
import 'package:provider/provider.dart';
import '../Providers/profile_provider.dart';

class ChatRoomProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();
  List<ChatRoom> _chatRooms = [];
  bool _isLoading = false;
  String _errorMessage = "";

  List<ChatRoom> get chatRooms => _chatRooms;
  bool get isLoading => _isLoading;
  Logger logger = Logger();
  String get errorMessage => _errorMessage;

  Future<void> fetchChatRooms(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      List<Map<String, dynamic>>? data =
          await _chatService.fetchChatRooms(userId);
      if (data != null) {
        logger.d(data);
        _chatRooms = data.map((json) => ChatRoom.fromJson(json)).toList();
      }
    } catch (e) {
      _errorMessage = "Failed to fetch chat rooms";
      logger.e("Error fetching chat rooms: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createChatRoom(BuildContext context, int participantId) async {
    try {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      final int currentUserId = provider.profile?.id ?? -1;

      if (currentUserId == -1) {
        logger.e("Error: Current user ID not found");
        return;
      }

      await _chatService.createChatRoom(context, participantId);

      // Fetch chat rooms for the current user, not the participant
      await fetchChatRooms(currentUserId);
    } catch (e) {
      logger.e("Error creating chat room: $e");
    }
  }

  void clearChatRooms() {
    _chatRooms.clear();
    notifyListeners();
  }
}
