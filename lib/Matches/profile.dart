import 'package:flutter/material.dart';
import '../Components/back.dart';
import 'profile_info.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final String name = 'Aditya';
  final int age = 22;
  final String gender = 'Male';
  final String location = 'Chennai, India';
  final int friendCount = 3213;
  final String about =
      'I am a boy with a great sense of humor and easy to go out with.';
  final List<String> interest = ['Football', 'Travel', 'Music'];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/mainpic.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Name and Location
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3, // Adjust as needed
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$name, ${age.toString()}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black45,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.red.shade900),
                    borderRadius: BorderRadius.circular(24),
                    gradient: LinearGradient(
                      colors: [Colors.red.shade50, Colors.red.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade100.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.red.shade900,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Say Hello',
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),

        // Scaffold with DraggableScrollableSheet
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: const Back(),
          ),
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              // About and Interests section
              Expanded(
                child: DraggableScrollableSheet(
                  initialChildSize: 0.5,
                  minChildSize: 0.3,
                  maxChildSize: 0.8,
                  builder: (context, scrollController) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: SizedBox(
                                width: 40,
                                height: 4,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'About',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black26,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              about,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Interests',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black26,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 8,
                              children: interest
                                  .map((label) => InterestChip(label: label))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                // Gender Container
                                ProfileInfoTile(
                                  icon: Icons.male,
                                  title: 'Gender',
                                  value: gender,
                                ),
                                // Age Container
                                ProfileInfoTile(
                                  icon: Icons.calendar_month_outlined,
                                  title: 'Age',
                                  value: '${age.toString()} years old',
                                ),
                                // Location Container
                                ProfileInfoTile(
                                  icon: Icons.people_alt,
                                  title: 'Friends',
                                  value: friendCount.toString(),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class InterestChip extends StatelessWidget {
  final String label;
  const InterestChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.red.shade100.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.red.shade700, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_soccer, // A generic sports icon for interest
            color: Colors.red.shade700,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.red.shade900,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
