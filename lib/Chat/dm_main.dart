import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Backend/chat_service.dart';

class DirectMessage extends StatefulWidget {
  final String profilepicurl;
  final String name;
  final int id;

  const DirectMessage({
    super.key,
    required this.profilepicurl,
    required this.name,
    required this.id,
  });

  @override
  State<DirectMessage> createState() => _DirectMessageState();
}

class _DirectMessageState extends State<DirectMessage> {
  late final ChatService _chatService;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  String status = 'Online';

  @override
  void initState() {
    super.initState();
    _chatService = ChatService();
    _chatService.connect(widget.id);

    // Preload some random messages
    _messages.addAll([
      {
        'sender': widget.name,
        'text': 'Hey! How are you?',
        'time': DateTime.now().subtract(const Duration(minutes: 5)).toString(),
        'read': 'true'
      },
      {
        'sender': 'Me',
        'text': 'I\'m good! Just working on some code.',
        'time': DateTime.now().subtract(const Duration(minutes: 4)).toString(),
        'read': 'true'
      },
      {
        'sender': widget.name,
        'text': 'Nice! What are you building?',
        'time': DateTime.now().subtract(const Duration(minutes: 3)).toString(),
        'read': 'true'
      },
      {
        'sender': 'Me',
        'text': 'A chat app. Trying to improve it.',
        'time': DateTime.now().subtract(const Duration(minutes: 2)).toString(),
        'read': 'true'
      },
      {
        'sender': widget.name,
        'text': 'That\'s awesome! Keep going.',
        'time': DateTime.now().subtract(const Duration(minutes: 1)).toString(),
        'read': 'true'
      },
    ]);

    // Listen for incoming messages
    _chatService.channel?.stream.listen((message) {
      final data = jsonDecode(message);
      setState(() {
        _messages.add({
          'sender': data['sender'] ?? widget.name,
          'text': data['message'] ?? '',
          'time': DateTime.now().toString(),
          'read': 'false',
        });
      });
    });
  }

  @override
  void dispose() {
    _chatService.channel?.sink.close();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _chatService.sendMessage(_messageController.text, 'Me', widget.name);

      setState(() {
        _messages.add({
          'sender': 'Me',
          'text': _messageController.text,
          'time': DateTime.now().toString(),
          'read': 'false',
        });
        _isTyping = false;
        status = 'Online';
      });

      _messageController.clear();
    }
  }

  void _onTyping(String text) {
    setState(() {
      _isTyping = text.isNotEmpty;
      status = _isTyping ? 'Typing...' : 'Online';
    });

    _chatService.updateTypingStatus('Me', widget.name, _isTyping);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.black.withOpacity(0.9),
                padding: const EdgeInsets.only(
                    top: 40, bottom: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: widget.profilepicurl.isNotEmpty
                          ? AssetImage(widget.profilepicurl)
                          : const AssetImage('assets/defaultprofile.png')
                              as ImageProvider,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 2),
                          Text(status,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _messages.length,
                  reverse: true,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    final message = _messages[_messages.length - index - 1];
                    final isMe = message['sender'] == 'Me';
                    return Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(message['sender']!,
                              style: TextStyle(
                                  color: isMe
                                      ? Colors.green[300]
                                      : Colors.grey[400],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.green[300]?.withOpacity(0.9)
                                  : Colors.grey[700]?.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(message['text']!,
                                        style: const TextStyle(
                                            color: Colors.white)),
                                    if (message['read'] == 'true')
                                      const Icon(Icons.check,
                                          color: Colors.blue, size: 16)
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    DateFormat('h:mm a').format(
                                        DateTime.parse(message['time']!)),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        onChanged: _onTyping,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.4),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
