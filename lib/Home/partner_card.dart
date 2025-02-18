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
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: Stack(
            children: [
              // Background image that fits correctly
              Positioned.fill(
                child: Image.asset(
                  'assets/mainpic.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              // Overlay content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Social Media Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const SvgIcon(
                              icon: SvgIconData('assets/insta.svg')),
                          iconSize: 24, // Reduce icon size slightly
                          color: Colors.white,
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const SvgIcon(
                              icon: SvgIconData('assets/twitter.svg')),
                          iconSize: 24,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Name and Age Text
                    Text(
                      '${match.name}, ${match.age}',
                      style: TextStyle(
                        fontSize: 18, // Slightly smaller text
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
                      match.location.toString(),
                      style: TextStyle(
                        fontSize: 14, // Make the location text smaller
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
      ),
    );
  }
}
