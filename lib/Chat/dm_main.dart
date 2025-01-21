import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class DirectMessage extends StatefulWidget {
  final String profilepicurl;
  final String name;

  const DirectMessage({
    super.key,
    required this.profilepicurl,
    required this.name,
  });

  @override
  State<DirectMessage> createState() => _DirectMessageState();
}

class _DirectMessageState extends State<DirectMessage> {
  late final IOWebSocketChannel _channel;
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isTyping = false;
  String status = 'Online';

  @override
  void initState() {
    super.initState();

    // Connect to WebSocket on page load
    _channel =
        IOWebSocketChannel.connect(Uri.parse('wss://echo.websocket.events'));

    _channel.stream.listen((message) {
      setState(() {
        _messages.add({
          'sender': widget.name,
          'text': message,
          'time': DateTime.now().toString(),
        });
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close(); // Close the WebSocket connection
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      _channel.sink.add(_messageController.text); // Send message over WebSocket
      setState(() {
        _messages.add({
          'sender': 'Me',
          'text': _messageController.text,
          'time': DateTime.now().toString(),
        });
        _isTyping = false; // Reset typing status
      });
      _messageController.clear(); // Clear message input field
    }
  }

  void _onTyping() {
    if (!_isTyping) {
      setState(() {
        _isTyping = true; // Mark as typing when user starts typing
        status = 'Typing...';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Layer
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Foreground Layer (Messages and Input Box)
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
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: widget.profilepicurl.isNotEmpty
                            ? AssetImage(widget.profilepicurl)
                            : const AssetImage('assets/defaultprofile.png'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            status,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Messages List
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
                          child: Text(
                            message['sender']!,
                            style: TextStyle(
                              color:
                                  isMe ? Colors.green[300] : Colors.grey[400],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
                            ),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.green[300]?.withOpacity(0.9)
                                  : Colors.grey[700]?.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text']!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    message['time']!,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.6),
                                      fontSize: 10,
                                    ),
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

              // Input Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _messageController,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              _onTyping(); // Mark user as typing
                            } else {
                              setState(() {
                                _isTyping = false;
                                status = 'Online'; // Reset typing status
                              });
                            }
                          },
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
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _sendMessage, // Send the message
                      icon: const Icon(Icons.send),
                      color: Colors.green[300],
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
