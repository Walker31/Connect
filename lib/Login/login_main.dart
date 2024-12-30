import 'package:connect/Login/Phone%20Login/phone_login.dart';
import 'package:flutter/material.dart';
import 'Sign Up/number.dart';

class MainLogin extends StatefulWidget {
  const MainLogin({super.key});

  @override
  State<MainLogin> createState() => MainLoginState();
}

class MainLoginState extends State<MainLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade200, Colors.red.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'assets/logincover.png',
                height: 200,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Let\'s meet new\npeople around you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PhoneLogin()));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade400],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.shade300,
                      offset: const Offset(2, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ListTile(
                  textColor: Colors.white,
                  iconColor: Colors.red,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade600,
                    ),
                    child: const Icon(
                      Icons.phone_in_talk,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text(
                    'Login with Phone',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      offset: const Offset(2, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ListTile(
                  textColor: Colors.red.shade900,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: ImageIcon(
                      const AssetImage('assets/google.png'),
                      color: Colors.red.shade900,
                    ),
                  ),
                  title: const Text(
                    'Login with Google',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GetNumber()),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Made with 🤍',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text('by Walker',
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
