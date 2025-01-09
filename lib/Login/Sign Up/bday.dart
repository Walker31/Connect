import 'package:connect/Components/back.dart';
import 'package:connect/Login/Sign%20Up/gender.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class EnterBday extends StatefulWidget {
  final Map<String, dynamic> formdata;
  const EnterBday({super.key, required this.formdata});

  @override
  State<EnterBday> createState() => EnterBdayState();
}

class EnterBdayState extends State<EnterBday> {
  TextEditingController nameController = TextEditingController();
  DateTime? selectedDate; // To store the selected date

  // Function to calculate age
  int calculateAge(DateTime birthDate) {
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          // Title
          Text(
            'Enter Your Birthday',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
          ),

          const SizedBox(height: 16),

          // Birthday Input Field
          TextField(
            readOnly: true,
            controller: nameController,
            keyboardType: TextInputType.none,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null) {
                setState(() {
                  selectedDate = pickedDate;
                  nameController.text = "${pickedDate.toLocal()}".split(' ')[0];
                });
              }
            },
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.red.shade900,
              ),
              hintText: 'Enter your Birthday',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red.shade900),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.red.shade900),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Step Progress Indicator
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StepProgressIndicator(
                  currentStep: 3,
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
                    Text('Step 3'),
                    Text('Step 6'),
                  ],
                ),
              ],
            ),
          )
        ]),
      ),

      // Floating Action Button
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
                if (selectedDate == null) {
                  // Show an alert or snackbar if the field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your Birthday'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Calculate age and store it in formdata
                  int age = calculateAge(selectedDate!);
                  widget.formdata['age'] = age;
                  // Navigate to the next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Gender(formdata: widget.formdata),
                    ),
                  );
                }
              },
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
