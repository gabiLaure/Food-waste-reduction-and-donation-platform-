import 'package:caritas/pages/login_page.dart';
import 'package:flutter/material.dart';

import '../home.dart';

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Registration Page',
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _mobileController,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Validate input and perform registration logic here
                // For simplicity, let's just print the entered values
                //print('First Name: ${_firstNameController.text}');
                //print('Last Name: ${_lastNameController.text}');
                //print('Email: ${_emailController.text}');
                //print('Mobile Number: ${_mobileController.text}');
                //print('Password: ${_passwordController.text}');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to the registration page when "Register" is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text("Already have an acount? Login"),
            )
          ],
        ),
      ),
    );
  }
}
