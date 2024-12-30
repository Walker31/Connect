import 'package:connect/Components/back.dart';
import 'package:connect/Login/Sign%20Up/bday.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class EnterName extends StatefulWidget {
  final Map<String, dynamic> formdata;
  const EnterName({super.key, required this.formdata});

  @override
  State<EnterName> createState() => EnterNameState();
}

class EnterNameState extends State<EnterName> {
  TextEditingController nameController = TextEditingController();

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
            'What\'s Your name?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade900,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              hintText: 'Enter your name',
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
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                StepProgressIndicator(
                  currentStep: 1,
                  selectedColor: Colors.red.shade900,
                  totalSteps: 5,
                  size: 10,
                  unselectedColor: Colors.grey.shade300,
                  roundedEdges: const Radius.circular(10),
                ),
                const SizedBox(height: 8),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Step 1'),
                    Text('Step 5'),
                  ],
                ),
              ],
            ),
          )
        ]),
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
                // Check if the name field is empty
                if (nameController.text.isEmpty) {
                  // Show an alert or snackbar if the field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your name'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Navigate to the next page if the name is entered
                  widget.formdata['name'] = nameController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EnterBday(
                      formdata : widget.formdata
                    )),
                  );
                }
              },
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
