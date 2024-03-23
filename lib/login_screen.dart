import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:green_guard_app/main.dart';
import 'package:green_guard_app/register_screen.dart';
import 'package:green_guard_app/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  Future<void> loginUser(
      String email, String password, BuildContext context) async {
    String apiUrl = 'http://127.0.0.1:8000/api/login';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Parse the response body to extract user email
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Save authentication token locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', responseData['data']['token']);
      prefs.setString('user_email', responseData['data']['email']);
      prefs.setString('username', responseData['data']['name']);

      prefs.setInt('user_id', responseData['data']['id']);

      Logger().d(responseData['data']['token']);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            selectedIndex: 2,
          ),
        ),
      );
    } else {
      if (kDebugMode) {
        print('Login failed');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController =
        TextEditingController(text: 'panha@gmail.com');
    TextEditingController passwordController =
        TextEditingController(text: '12345678');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextButton(
                onPressed: () {
                  String email = emailController.text;
                  String password = passwordController.text;

                  // Validate email and password
                  if (email.isEmpty || password.isEmpty) {
                    // Show error message if fields are empty
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Validation Error"),
                          content: const Text(
                              "Please enter both email and password."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    loginUser(email, password, context);
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                child: const Text('Register'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
