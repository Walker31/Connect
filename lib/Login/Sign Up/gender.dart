import 'package:connect/Components/back.dart';
import 'package:connect/Login/Sign%20Up/interests.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Gender extends StatefulWidget {
  final Map<String, dynamic> formdata;
  const Gender({super.key, required this.formdata});

  @override
  State<Gender> createState() => GenderState();
}

class GenderState extends State<Gender> {
  TextEditingController nameController = TextEditingController();
  String? selectedGender;

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
              'Enter Your Gender',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'Male';
                  });
                },
                child: GenderCards(
                  gender: 'Male',
                  isSelected: selectedGender == 'Male',
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedGender = 'Female';
                  });
                },
                child: GenderCards(
                  gender: 'Female',
                  isSelected: selectedGender == 'Female',
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StepProgressIndicator(
                    currentStep: 4,
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
                      Text('Step 4'),
                      Text('Step 6'),
                    ],
                  ),
                ],
              ),
            )
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
                if (selectedGender == null) {
                  // Show an alert or snackbar if no gender is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select your gender'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  widget.formdata['gender'] = selectedGender.toString();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Interests(formdata: widget.formdata)));
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

class GenderCards extends StatelessWidget {
  final String gender;
  final bool isSelected;

  const GenderCards({super.key, required this.gender, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.pink.shade900 : Colors.white),
            borderRadius: BorderRadius.circular(16)),
        child: Card(
          borderOnForeground: false,

          color: isSelected ? Colors.white70 : Colors.white, // Light background
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: 130,
            height: 140,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Colors.red.shade900
                          : Colors.pink.shade900,
                    ),
                    child: Icon(
                      gender == 'Male' ? Icons.male : Icons.female,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gender,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
