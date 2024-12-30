import 'package:connect/Model/post.dart';
import 'package:flutter/material.dart';
import '../Components/action_button.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  Offset dragPosition = const Offset(300, 100);
  bool _isDraggable = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    Post card = widget.post;
    return Center(
      child: Stack(
        children: [
          // Background Card
          Container(
            width: MediaQuery.of(context).size.width * 0.8, // Responsive width
            height:
                MediaQuery.of(context).size.height * 0.4, // Responsive height
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage(card.pic.toString()),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  16, 16, 72, 16), // Added right padding to avoid overlap
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_transportation,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          card.interest.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Caption Text
                  Text(
                    card.caption,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // User Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(card.displayPic.toString()),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            card.author.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            card.location.toString(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          // Draggable Action Buttons
          Positioned(
            right: 0,
            bottom: 100,
            child: GestureDetector(
              onPanUpdate: _isDraggable
                  ? (details) {
                      setState(() {
                        dragPosition += details.delta;
                      });
                    }
                  : null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isDraggable = !_isDraggable;
                        isExpanded = !isExpanded;
                      });
                    },
                    icon: Icon(
                      isExpanded
                          ? Icons.arrow_back_ios
                          : Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ),
                  if (isExpanded)
                    Opacity(
                      opacity: 0.5,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                          color: Colors.white,
                        ),
                        child: const Column(
                          children: [
                            ActionButton(
                              icon: Icon(Icons.thumb_up_alt_rounded),
                              toolTip: 'Like',
                            ),
                            SizedBox(height: 16),
                            ActionButton(
                              icon: Icon(Icons.chat_bubble),
                              toolTip: 'Connect',
                            ),
                            SizedBox(height: 16),
                            ActionButton(
                              icon: Icon(Icons.share_rounded),
                              toolTip: 'Share',
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
