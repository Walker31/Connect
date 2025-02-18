import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  SwipePageState createState() => SwipePageState();
}

class SwipePageState extends State<SwipePage> {
  Logger logger = Logger();
  final List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final List<Map<String, dynamic>> _profiles = [
    {
      "name": "Alice",
      "age": 23,
      "bio": "Loves traveling and photography",
      "color": Colors.red
    },
    {
      "name": "Bob",
      "age": 27,
      "bio": "Coffee addict and music enthusiast",
      "color": Colors.blue
    },
    {
      "name": "Charlie",
      "age": 25,
      "bio": "Tech geek and fitness lover",
      "color": Colors.green
    },
    {
      "name": "Diana",
      "age": 22,
      "bio": "Bookworm and nature lover",
      "color": Colors.yellow
    },
    {
      "name": "Ethan",
      "age": 26,
      "bio": "Aspiring chef and foodie",
      "color": Colors.orange
    },
  ];

  @override
  void initState() {
    super.initState();

    for (var profile in _profiles) {
      _swipeItems.add(SwipeItem(
        content: profile,
        likeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Liked ${profile['name']}"),
            duration: const Duration(milliseconds: 500),
          ));
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Nope ${profile['name']}"),
            duration: const Duration(milliseconds: 500),
          ));
        },
        superlikeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Superliked ${profile['name']}"),
            duration: const Duration(milliseconds: 500),
          ));
        },
        onSlideUpdate: (SlideRegion? region) {
          logger.d("Region $region");
          return Future.value();
        },
      ));
    }

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Find Your Partner"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
                var profile = _swipeItems[index].content;
                return PartnerCard(profile: profile);
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("No more profiles!"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                logger.d("Swiped: ${item.content['name']}, index: $index");
              },
              upSwipeAllowed: true,
              fillSpace: true,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _swipeButton("Nope", Colors.red, () {
                _matchEngine.currentItem!.nope();
              }),
              _swipeButton("Superlike", Colors.blue, () {
                _matchEngine.currentItem?.superLike();
              }),
              _swipeButton("Like", Colors.green, () {
                _matchEngine.currentItem?.like();
              }),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _swipeButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      onPressed: onPressed,
      child:
          Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}

class PartnerCard extends StatelessWidget {
  final Map<String, dynamic> profile;

  const PartnerCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: profile['color'],
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              profile['name'],
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "${profile['age']} years old",
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 10),
            Text(
              profile['bio'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
