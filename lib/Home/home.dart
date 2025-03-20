import 'package:connect/Home/filter.dart';
import 'package:flutter/material.dart';
import 'package:connect/Home/partner_card.dart';
import 'package:connect/Model/profile.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../Backend/profile_api.dart';
import '../Providers/profile_provider.dart';
import '../Settings/settings_main.dart';
import '../Components/home_button.dart';
import '../Backend/swiping.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger logger = Logger();
  List<Profile> profiles = [];
  final ProfileApi _profileApi = ProfileApi();

  double slideDirection = 0;
  bool animateCard = true;

  @override
  void initState() {
    super.initState();
    fetchprofiles();
  }

  Future<void> fetchprofiles() async {
    try {
      final fetchedprofiles = await _profileApi.getProfiles(context);
      setState(() {
        profiles = fetchedprofiles;
      });
    } catch (e) {
      logger.e('Error fetching profiles: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to load profiles. Please try again.')),
        );
      }
    }
  }

  Future<void> swipe(String userId, String partnerId, String action) async {
    try {
      await Match().swipeResult(context, userId, partnerId, action);
    } catch (e) {
      logger.e('Error during swiping: $e');
    }
  }

  void removeProfile(int direction) {
    if (profiles.isNotEmpty) {
      setState(() {
        slideDirection = direction.toDouble();
        animateCard = false;
      });

      Future.delayed(const Duration(milliseconds: 400), () {
        if (profiles.isNotEmpty) {
          setState(() {
            profiles.removeAt(0);
            slideDirection = 0;
            animateCard = true;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(1),
        foregroundColor: Colors.red,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const FilterWidget(),
          );
        },
        child: const Icon(
          Icons.filter_list,
          size: 28,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, size: 32),
            color: Colors.red.shade900,
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Settings()),
              );
            },
            icon: const Icon(Icons.person, size: 32),
            color: Colors.red.shade900,
          ),
        ],
        leading: Icon(Icons.heart_broken, color: Colors.red.shade900, size: 32),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: profiles.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PartnerCard(profile: profiles.first)
                        .animate(target: animateCard ? 1 : 0)
                        .fadeIn(duration: 400.ms)
                        .scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1))
                        .then()
                        .slideX(
                            begin: slideDirection, end: 0, duration: 400.ms),
                  )
                : const Center(child: Text("No more profiles")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HomeButton(
                color: Colors.red,
                icon: const SvgIcon(
                  icon: SvgIconData('assets/svgIcons/cross.svg'),
                ),
                onPressed: () {
                  if (provider.profile?.id != null && profiles.isNotEmpty) {
                    swipe(
                      provider.profile!.id.toString(),
                      profiles.first.id.toString(),
                      'dislike',
                    );
                    removeProfile(1);
                  }
                  removeProfile(-1);
                },
              ),
              const SizedBox(width: 20),
              HomeButton(
                color: Colors.red,
                icon: const Icon(color: Colors.white, Icons.favorite),
                onPressed: () {
                  if (provider.profile?.id != null && profiles.isNotEmpty) {
                    swipe(
                      provider.profile!.id.toString(),
                      profiles.first.id.toString(),
                      'like',
                    );
                    removeProfile(1);
                  }
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
