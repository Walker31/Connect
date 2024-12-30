import 'package:connect/Matches/match_card.dart';
import 'package:connect/Matches/profile.dart';
import 'package:flutter/material.dart';
import 'circle.dart';

class Match extends StatefulWidget {
  const Match({super.key});

  @override
  State<Match> createState() => MatchState();
}

class MatchState extends State<Match> {
  final int matchCount = 4; // Change this value to dynamically update the count

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Matches',
            style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleWithIcon(
                  imagePath: 'assets/profile.jpg', // Pass the image path
                  icon: Icons.favorite, // Pass the icon you want
                  title: 'Likes',
                  count: 32,
                ),
                CircleWithIcon(
                  imagePath: 'assets/pic.png', // Pass the image path
                  icon: Icons.chat_bubble, // Pass the icon you want
                  title: 'Connect',
                  count: 41,
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Text('Your Matches',
                    style: TextStyle(
                        fontSize: 23,
                        color: Colors.red.shade900,
                        fontWeight: FontWeight.bold)),
                Text(
                  ' ${matchCount.toString()}',
                  style: TextStyle(
                      fontSize: 23,
                      color: Colors.red.shade200,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust for the number of columns
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: matchCount,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()));
                    },
                    child: const MatchCard(
                      imagePath: 'assets/mainpic.jpg',
                      name: 'James',
                      age: 20,
                      location: 'Hanover',
                      distance: '1.3 km away',
                      matchPercentage: '100% Match',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
