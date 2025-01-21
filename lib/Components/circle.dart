import 'package:flutter/material.dart';

class CircleWithIcon extends StatelessWidget {
  final String imagePath;
  final IconData icon;
  final String title;
  final int count;

  const CircleWithIcon(
      {super.key,
      required this.imagePath,
      required this.icon,
      required this.title,
      required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            alignment:
                Alignment.center, // Centers the children within the Stack
            children: [
              // Circle container with image
              Container(
                padding: const EdgeInsets.all(
                    8), // Adjust the padding to create the gap
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    style: BorderStyle
                        .solid, // Changed to solid for better visualization
                    color: Colors.red.shade400,
                    width: 2, // Adjust the width of the border
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 80, // Set the width of the image
                    height: 80, // Set the height of the image
                    fit: BoxFit.cover, // Ensure the image covers the clip area
                  ),
                ),
              ),
              // Icon in the center of the circle
              Opacity(
                opacity: 1,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 40, // You can adjust the size as needed
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                title,
                style:
                    const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(
                ' $count',
                style: TextStyle(
                    color: Colors.red.shade900, fontWeight: FontWeight.bold),
              )
            ],
          )
        ],
      ),
    );
  }
}
