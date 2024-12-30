import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';

import '../Model/profile.dart';

class PartnerCard extends StatefulWidget {
  final Profile profile;
  const PartnerCard({super.key, required this.profile});

  @override
  State<PartnerCard> createState() => PartnerState();
}

class PartnerState extends State<PartnerCard> {
  
  @override
  Widget build(BuildContext context) {
    Profile match = widget.profile;
    return Container(
      margin: const EdgeInsets.all(
          16), // Add margin to provide space around the card
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4), // Shadow position
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
            16), // Clip the image to match the border radius
        child: Stack(
          children: [
            // Background image with doubled height
            Image.asset(
              'assets/mainpic.jpg',
              width: double.infinity, // Make image fill the container
              height: 500, // Doubled the height for a larger image
              fit: BoxFit.cover, // Ensures the image is scaled properly
            ),
            // Overlay content (Icons and Text)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Social Media Icons (Twitter & Instagram)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const SvgIcon(
                            icon: SvgIconData('assets/insta.svg')),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const SvgIcon(
                            icon: SvgIconData('assets/twitter.svg')),
                        iconSize: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Space between icons and text
                  // Name and Age Text
                  Text(
                    '${match.name}, ${match.age}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Location Text
                  Text(
                    'Chennai, India',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          offset: const Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
