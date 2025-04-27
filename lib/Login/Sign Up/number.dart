import 'package:connect/Components/back.dart';
import 'package:connect/Login/Sign%20Up/verify.dart';
import 'package:flutter/material.dart';

class GetNumber extends StatefulWidget {
  const GetNumber({super.key});

  @override
  State<GetNumber> createState() => GetNumberState();
}

class GetNumberState extends State<GetNumber> {
  TextEditingController numbercontroller = TextEditingController();

  Map<String, dynamic> formdata = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Heading Text
            const Text(
              'Enter your Number',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // Phone Number Input
            TextField(
              controller: numbercontroller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                prefixIcon: Icon(Icons.phone, color: Colors.red.shade900),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.red.shade900),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.red.shade900),
                ),
              ),
              maxLength: 10, // Assuming the phone number has 10 digits
            ),
            const SizedBox(height: 24),

            // Submit Button
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (numbercontroller.text.isNotEmpty &&
                        numbercontroller.text.length == 10) {
                      formdata['phone_no'] = numbercontroller.text;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VerifyNumber(formData: formdata)));
                    } else {
                      // Show error if the number is invalid
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter a valid phone number')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade900, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 40),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
