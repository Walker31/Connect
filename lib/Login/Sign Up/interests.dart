import 'package:connect/Login/Sign%20Up/upload.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../../Components/back.dart';

class Interests extends StatefulWidget {
  final Map<String, dynamic> formdata;
  const Interests({super.key, required this.formdata});

  @override
  State<Interests> createState() => InterestsState();
}

class InterestsState extends State<Interests> {
  List<String> interest = [
    'Gaming',
    'Dancing',
    'Language',
    'Music',
    'Movie',
    'Photography',
    'Architecture',
    'Fashion',
    'Book',
    'Writing',
    'Nature',
    'Painting',
    'Football',
    'People',
    'Animals',
    'Gym & Fitness'
  ];

  List<String> selectedInterests = [];

  void toggleInterest(String interest) {
    setState(() {
      if (selectedInterests.contains(interest)) {
        selectedInterests.remove(interest);
      } else {
        if (selectedInterests.length < 5) {
          selectedInterests.add(interest);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can only select up to 5 interests.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: const Back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Select up to 5 interests',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 16),

            // Interests List
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 10, // Horizontal spacing
                  runSpacing: 10, // Vertical spacing
                  children: List.generate(interest.length, (index) {
                    return GestureDetector(
                      onTap: () => toggleInterest(interest[index]),
                      child: InterestCard(
                        interest: interest[index],
                        interestIcon: const Icon(
                          Icons.star,
                          color: Colors.white70,
                        ),
                        isSelected: selectedInterests.contains(interest[index]),
                      ),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Step Progress Indicator
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StepProgressIndicator(
                  currentStep: 5,
                  selectedColor: Colors.red.shade900,
                  totalSteps: 6,
                  size: 10,
                  unselectedColor: Colors.grey.shade300,
                  roundedEdges: const Radius.circular(10),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Step 5'),
                    Text('Step 6'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              elevation: 4,
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade900,
              onPressed: () {
                if (selectedInterests.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select at least one interest'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  widget.formdata['interests'] = selectedInterests;
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UploadImage(
                        formdata: widget.formdata
                      )));
                }
              },
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class InterestCard extends StatelessWidget {
  final String interest;
  final Icon interestIcon;
  final bool isSelected;

  const InterestCard({
    super.key,
    required this.interest,
    required this.interestIcon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? Colors.pink.shade300 : Colors.white70,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          interestIcon,
          const SizedBox(width: 8),
          Text(
            interest,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
