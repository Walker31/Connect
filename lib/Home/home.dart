import 'package:connect/Backend/profile_api.dart';
import 'package:connect/Home/partner_card.dart';
import 'package:connect/Matches/profile.dart';
import 'package:connect/Model/profile.dart';
import 'package:connect/Settings/settings_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:logger/logger.dart';

import '../Components/home_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomeState();
}

class HomeState extends State<HomePage> with SingleTickerProviderStateMixin {
  Logger logger = Logger();
  List<Profile> profiles = [];
  final ProfileApi _profileApi = ProfileApi();
  int index = 0;

  // Animation Controllers
  late AnimationController _animationController;
  bool isSwiping = false;
  double dragStartX = 0.0;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    fetchProfiles();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  Future<void> fetchProfiles() async {
    try {
      final fetchedProfiles = await _profileApi.getProfiles(context);
      setState(() {
        profiles = fetchedProfiles;
      });
    } catch (e) {
      logger.e('Error fetching profiles: $e');
    }
  }

  void swipeCard(int index) {
    if (profiles.isNotEmpty) {
      setState(() {
        profiles.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red.shade900),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 32,
              ),
              color: Colors.red.shade900,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
            icon: const Icon(
              Icons.person,
              size: 32,
            ),
            color: Colors.red.shade900,
          ),
        ],
        leading: Icon(
          Icons.heart_broken,
          color: Colors.red.shade900,
          size: 32,
        ),
        title: Text(
          'Connect',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Colors.red.shade900,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: profiles.isEmpty
                ? Center(
                    child: Text(
                      "No more matches found near you.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Stack(
                    children: profiles
                        .asMap()
                        .entries
                        .map((entry) {
                          index = entry.key;
                          Profile profile = entry.value;

                          // Calculate animation position
                          double topPosition = 10.0 + index * 10;
                          double horizontalPosition = 10.0 + index * 10;
                          double opacityValue =
                              1 - (index * 0.1).clamp(0.0, 1.0);

                          return AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            top: topPosition,
                            left: horizontalPosition,
                            right: horizontalPosition,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: opacityValue,
                              child: GestureDetector(
                                onDoubleTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfilePage(
                                                profile: profile,
                                                
                                              )));
                                },
                                onHorizontalDragStart: (details) {
                                  dragStartX = details.globalPosition.dx;
                                },
                                onHorizontalDragUpdate: (details) {
                                  setState(() {
                                    isSwiping = true;
                                  });
                                },
                                onHorizontalDragEnd: (details) {
                                  if (isSwiping) {
                                    setState(() {
                                      profiles.removeAt(index);
                                      isSwiping = false;
                                    });
                                  }
                                },
                                child: PartnerCard(
                                  profile: profile,
                                ),
                              ),
                            ),
                          );
                        })
                        .toList()
                        .reversed // Ensure topmost card is interactive
                        .toList(),
                  ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HomeButton(
                color: const Color.fromRGBO(198, 40, 40, 1).withOpacity(0.7),
                icon: const SvgIcon(
                  icon: SvgIconData('assets/svgIcons/cross.svg'),
                ),
                onPressed: () {
                  if (profiles.isNotEmpty) {
                    setState(() {
                      profiles.removeAt(index);
                    });
                  }
                },
              ),
              const SizedBox(
                width: 20,
              ),
              HomeButton(
                color: Colors.red.shade800.withOpacity(0.7),
                icon: const Icon(Icons.star),
                onPressed: () {
                  // Handle "star" functionality
                },
              ),
              const SizedBox(
                width: 20,
              ),
              HomeButton(
                color: Colors.red.shade800.withOpacity(0.7),
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  if (profiles.isNotEmpty) {
                    setState(() {
                      profiles.removeAt(index);
                    });
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
