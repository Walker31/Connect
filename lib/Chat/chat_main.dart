import 'package:connect/Chat/dm_main.dart';
import 'package:connect/Providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../Model/chat_room.dart';
import '../Providers/chat_provider.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  bool isExpanded = false;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  Timer? _debounce;
  Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchChatRooms();
  }

  void _fetchChatRooms() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final userId = profileProvider.profile?.id;

    if (userId != null) {
      Future.microtask(() async {
        try {
          await Provider.of<ChatRoomProvider>(context, listen: false)
              .fetchChatRooms(userId);
        } catch (e) {
          logger.e("Error fetching chat rooms: $e");
        }
      });
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        searchQuery = value.trim();
      });
    });
  }

  void toggleSearchBar() {
    setState(() {
      if (isExpanded) {
        searchController.clear();
        searchQuery = "";
      }
      isExpanded = !isExpanded;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Consumer<ChatRoomProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (chatProvider.errorMessage.isNotEmpty) {
                return _buildErrorUI();
              }
              List<ChatRoom> filteredChatRooms = chatProvider.chatRooms
                  .where((chat) =>
                      chat.participant2.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      (chat.lastMessage
                              ?.toLowerCase()
                              .contains(searchQuery.toLowerCase()) ??
                          false))
                  .toList();
              return Expanded(child: _buildChatList(filteredChatRooms));
            },
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.red.shade500,
      title: const Text(
        'Chat',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      actions: [
        isExpanded
            ? _buildSearchField()
            : IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: toggleSearchBar,
              ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 250,
        height: 40,
        child: TextField(
          controller: searchController,
          onChanged: _onSearchChanged,
          autofocus: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.cancel, color: Colors.red.shade700),
              onPressed: toggleSearchBar,
            ),
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Failed to load chats',
            style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _fetchChatRooms,
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red.shade500),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<ChatRoom> chatRooms) {
    if (chatRooms.isEmpty) {
      return Center(
        child: Text(
          'No Chats Found',
          style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.separated(
      itemCount: chatRooms.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey.shade300,
        thickness: 1,
        indent: 70,
        endIndent: 20,
      ),
      itemBuilder: (context, index) {
        final chatRoom = chatRooms[index];
        return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DirectMessage(
                          profilepicurl: chatRoom.participant2.profilePicture,
                          name: chatRoom.participant2.name,
                          id: chatRoom.participant2.id)));
            },
            child: _buildChatTile(chatRoom));
      },
    );
  }

  Widget _buildChatTile(ChatRoom chatRoom) {
    final displayName = chatRoom.participant2.name;
    final profilePicUrl = chatRoom.participant2.profilePicture;
    bool isNotEmpty = profilePicUrl.isNotEmpty;
    ImageProvider profilePic;
    try {
      profilePic = const AssetImage('assets/defaultprofile.png');
    } catch (e) {
      logger.e(e);
      profilePic = const AssetImage('assets/defaultprofile.png');
    }

    return ListTile(
      leading: CircleAvatar(
        onBackgroundImageError: (_, __) {
          setState(() {
            logger.d("Entering here");
            isNotEmpty = false;
          });
        },
        backgroundImage: isNotEmpty
            ? profilePic
            : const AssetImage('assets/defaultprofile.png'),
        radius: 25,
      ),
      title: Text(
        displayName,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chatRoom.lastMessage ?? "No messages yet",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Text(
        _getMessageTime(chatRoom.lastUpdated),
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }

  String _getMessageTime(DateTime? messageTime) {
    if (messageTime == null) return "";
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    if (messageTime.year == now.year &&
        messageTime.month == now.month &&
        messageTime.day == now.day) {
      return DateFormat('HH:mm').format(messageTime);
    } else if (messageTime.year == yesterday.year &&
        messageTime.month == yesterday.month &&
        messageTime.day == yesterday.day) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(messageTime);
    }
  }
}
