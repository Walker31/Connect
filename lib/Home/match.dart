import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class MatchPage extends StatefulWidget {
  final String matchName;
  const MatchPage({super.key, required this.matchName});

  @override
  State<MatchPage> createState() => _MatchPageState();
}

class _MatchPageState extends State<MatchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Match Title
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              child: Text(
                "It's a Match!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Match Description
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: Text(
                "You and ${widget.matchName} liked each other 💕",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red.shade800,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Heart Animation (Placed Between Text & Button)
            Pulse(
              duration: const Duration(seconds: 2),
              infinite: true,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade700,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade400.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Start Chatting Button
            FadeInUp(
              delay: const Duration(milliseconds: 700),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                ),
                icon: const Icon(Icons.message, color: Colors.white),
                label: const Text(
                  "Start Chatting",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Keep Browsing Button
            FadeInUp(
              delay: const Duration(milliseconds: 900),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Keep Browsing",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
