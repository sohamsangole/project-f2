import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'package:project_f2/components/mediumtext.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<void> login() async {
    final url = Uri.parse('http://10.0.2.2:8000/spotify/check-auth');
    try {
      final response = await http.post(url);
      print(response.statusCode);
      if (response.statusCode == 200) {
        // Handle successful login
        await launchUrl(url);
        print('Login successful');
      } else {
        print('Login failed');
      }
    } catch (e) {
      // Handle network or server errors
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/spotify.png',
              height: MediaQuery.of(context).size.width / 4,
            ),
            const SizedBox(height: 20),
            const MediumText(data: "Continue With Spotify"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: login,
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
