/*import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("App Title"),
      backgroundColor: Colors.blue,),
      backgroundColor: Colors.indigo,
      body: const SafeArea(child: Text("Login Page", style: TextStyle(color: Colors.black),))
    );
  }
}*/

import 'package:flutter/material.dart';

import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Validate credentials and perform login logic here
                // For simplicity, let's just print the entered values
                //print('Username: ${_usernameController.text}');
                //print('Password: ${_passwordController.text}');
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    // Navigate to the registration page when "Register" is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to the forgot password page when "Forgot Password" is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
