import 'package:connect/Components/back.dart';
import 'package:connect/Login/Sign%20Up/bday.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Password extends StatefulWidget {
  final Map<String, dynamic> formdata;
  const Password({super.key, required this.formdata});

  @override
  State<Password> createState() => PasswordState();
}

class PasswordState extends State<Password> {
  TextEditingController passwordController = TextEditingController();
  String passwordStrength = "Weak"; // Default password strength
  Color strengthColor = Colors.red.shade900; // Default color for weak password

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_checkPasswordStrength);
  }

  @override
  void dispose() {
    passwordController.removeListener(_checkPasswordStrength);
    super.dispose();
  }

  // Function to check password strength in real-time
  void _checkPasswordStrength() {
    String password = passwordController.text;
    if (password.isEmpty) {
      setState(() {
        passwordStrength = "Weak";
        strengthColor = Colors.red.shade900;
      });
    } else if (password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$&*~]'))) {
      setState(() {
        passwordStrength = "Strong";
        strengthColor = Colors.green.shade900;
      });
    } else if (password.length >= 6) {
      setState(() {
        passwordStrength = "Medium";
        strengthColor = Colors.orange.shade700;
      });
    } else {
      setState(() {
        passwordStrength = "Weak";
        strengthColor = Colors.red.shade900;
      });
    }
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
              'Set Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade900,
              ),
            ),
            const SizedBox(height: 16),
            // Password TextField
            TextField(
              controller: passwordController,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              decoration: InputDecoration(
                hintText: 'Enter your password',
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
            // Password Strength Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(passwordStrength, style: TextStyle(color: strengthColor)),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: strengthColor.withOpacity(0.2),
                  ),
                  child: LinearProgressIndicator(
                    value: passwordStrength == "Strong"
                        ? 1.0
                        : passwordStrength == "Medium"
                            ? 0.6
                            : 0.3,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation(strengthColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StepProgressIndicator(
                    currentStep: 2,
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
                      Text('Step 2'),
                      Text('Step 6'),
                    ],
                  ),
                ],
              ),
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
                // Check if the password field is empty
                if (passwordController.text.isEmpty) {
                  // Show an alert or snackbar if the field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter your password'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  // Navigate to the next page if the password is entered
                  widget.formdata['password'] = passwordController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EnterBday(formdata: widget.formdata)),
                  );
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
