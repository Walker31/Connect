import 'package:connect/Components/back.dart';
import 'package:connect/Login/Sign%20Up/name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerifyNumber extends StatefulWidget {
  final Map<String, dynamic> formData;
  const VerifyNumber({super.key, required this.formData});

  @override
  State<VerifyNumber> createState() => VerifyNumberState();
}

class VerifyNumberState extends State<VerifyNumber> {
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Back(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Enter 4-digits code',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 16),

            // OTP Input Field
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OtpTextField(
                keyboardType: TextInputType.number,
                showCursor: true,
                showFieldAsBox: true,
                numberOfFields: 4,
                borderColor: Colors.red.shade900,
                focusedBorderColor: Colors.red,
                onSubmit: (value) {
                  setState(() {
                    otp = value;
                  });
                  // Add OTP validation logic here
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Didn\'t receive the code?',
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            const SizedBox(height: 16),
            // Continue Button
            ElevatedButton(
              onPressed: () {
                if (otp.length == 4) {
                  Map<String, dynamic> formdata = widget.formData;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EnterName(formdata: formdata),
                    ),
                  );
                } else {
                  // Show error if OTP is incomplete
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid OTP')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 40,
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
