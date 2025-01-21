import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dm_main.dart';

class ChatMain extends StatefulWidget {
  const ChatMain({super.key});

  @override
  State<ChatMain> createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  bool isExpanded = false;
  TextEditingController searchController = TextEditingController();
  List<ChatRoom> chatRooms = [
    ChatRoom(
      name: 'John Doe',
      profilePicUrl: 'assets/dp/2.jpg',
      lastMessage: 'Hey, how are you?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    ChatRoom(
      name: 'Jane Smith',
      profilePicUrl: 'assets/dp/4.jpg',
      lastMessage: 'Let\'s catch up soon!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ChatRoom(
      name: 'Alice Johnson',
      profilePicUrl: 'assets/dp/5.jpg',
      lastMessage: 'Got your message!',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  String searchQuery = "";

  List<ChatRoom> get filteredChatRooms {
    return chatRooms
        .where((chat) =>
            chat.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
            chat.lastMessage.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 250,
                    height: 40,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      autofocus: true,
                      decoration: InputDecoration(
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
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
                )
              : IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: toggleSearchBar,
                ),
        ],
      ),
      body: filteredChatRooms.isEmpty
          ? Center(
              child: Text(
                'No Chats Found',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.separated(
              itemCount: filteredChatRooms.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                indent: 70,
                endIndent: 20,
              ),
              itemBuilder: (context, index) {
                final chatRoom = filteredChatRooms[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: chatRoom.profilePicUrl.isNotEmpty
                        ? AssetImage(chatRoom.profilePicUrl)
                        : const AssetImage('assets/defaultprofile.png'),
                    radius: 25,
                  ),
                  title: Text(
                    chatRoom.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    chatRoom.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: Text(
                    _getMessageTime(chatRoom.lastMessageTime),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DirectMessage(
                                profilepicurl: chatRoom.profilePicUrl,
                                name: chatRoom.name)));
                  },
                );
              },
            ),
    );
  }

  String _getMessageTime(DateTime messageTime) {
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
      return DateFormat('dd/MM').format(messageTime);
    }
  }
}

class ChatRoom {
  final String name;
  final String profilePicUrl;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatRoom({
    required this.name,
    required this.profilePicUrl,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
