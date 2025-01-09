import 'package:connect/Backend/profile_api.dart';
import 'package:connect/Home/partner_card.dart';
import 'package:connect/Model/profile.dart';
import 'package:connect/Settings/settings_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  Logger logger = Logger();
  List<Profile> profiles = [];
  final ProfileApi _profileApi = ProfileApi();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    fetchProfiles();
    super.initState();
  }

  Future<void> fetchProfiles() async {
    try {
      final fetchedProfiles = await _profileApi.getProfiles(context);
      setState(() {
        profiles = fetchedProfiles;
      });
    } catch (e) {
      logger.e('Error fetching posts: $e');
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
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
            height: 60,
          ),
          Expanded(
            child: Column(
              children: [
                Center(
                    child: PartnerCard(
                        profile:
                            Profile(interests: [], gender: 'Male', age: 20))),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromRGBO(198, 40, 40, 1)
                              .withOpacity(0.7)),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {},
                        icon: const SvgIcon(
                          icon: SvgIconData('assets/svgIcons/cross.svg'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.shade800.withOpacity(0.7)),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.star, color: Colors.white)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.shade800.withOpacity(0.7)),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
