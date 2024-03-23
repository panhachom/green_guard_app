import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_guard_app/main.dart';
import 'package:green_guard_app/user_profile.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key});

  Future<void> registerUser(
      String name, String email, String password, BuildContext context) async {
    String apiUrl = 'http://127.0.0.1:8000/api/register';

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {'name': name, 'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      // Parse the response body to extract user details
      final Map<String, dynamic> responseData = json.decode(response.body);

      Logger().d(responseData);

      // Save authentication token and user details locally
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('auth_token', responseData['data']['token']);
      prefs.setString('user_email', responseData['data']['email']);
      prefs.setString('username', responseData['data']['name']);
      prefs.setInt('user_id', responseData['data']['id']);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            selectedIndex: 2,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Register Fails"),
            content: const Text("Something went wrong"),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: '1Johnnyggod');
    TextEditingController emailController =
        TextEditingController(text: '1test@gmail.com');
    TextEditingController passwordController =
        TextEditingController(text: '12345678');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
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
                  String name = nameController.text;
                  String email = emailController.text;
                  String password = passwordController.text;

                  // Validate inputs
                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Validation Error"),
                          content: const Text(
                              "Please enter name, email, and password."),
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
                    registerUser(name, email, password, context);
                  }
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
