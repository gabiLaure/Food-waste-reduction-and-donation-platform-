import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../admin/screens/edit_grocery_regis.dart';
import '../../home.dart';
import '../Orphanage/orphanage_registration_page.dart';
import '../Restaurant/restaurant_registration_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  // Controllers for user input fields
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String accountTypeName = ''; // This should come from a dropdown or selection
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  double? circularProgressVal;
  // Validation function to check if inputs are valid
  bool validateUser() {
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  // Authenticate user with Firebase Auth
  void authenticateUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty')),
      );
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // add user to firestore with multiple images
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid.toString())
          .set({
            'userUid': userCredential.user!.uid.toString(),
            'fullname': fullNameController.text.trim(),
            'phone': phoneController.text.trim(),
            'accountType': accountTypeName,
            'email': emailController.text.trim()
          })
          .then(
            (value) => redirectUser(context),
          )
          .catchError((error) => sendErrorCode(error.toString()));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = 'Registration failed. Please try again.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  void sendErrorCode(error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  void redirectUser(context) {
    // Navigate based on account type
    switch (accountTypeName) {
      case 'Individual':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your User Account has been created')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 'Orphanage':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Your User account has been created please fill the Ophanage Registration form')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrphanageRegistration()),
        );
        break;
      case 'Restaurant':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Your User account has been created please fill the Restaurant Registration form')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RestaurantRegistration()),
        );
        break;
      case 'Supermarket':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Your User account has been created please fill the Supermarket Registration form')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroceryRegistration()),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid account type')),
        );
        return;
    }
  }

  // Button to handle registration
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Registration')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name input
                        TextFormField(
                          controller: fullNameController,
                          decoration: InputDecoration(labelText: 'Full Name'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Phone input
                        TextFormField(
                          controller: phoneController,
                          decoration:
                              InputDecoration(labelText: 'Phone Number'),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Email input
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Password input
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password should be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Account type dropdown (example)
                        DropdownButtonFormField<String>(
                          value:
                              accountTypeName.isEmpty ? null : accountTypeName,
                          hint: Text('Select Account Type'),
                          items: [
                            'Individual',
                            'Orphanage',
                            'Restaurant',
                            'Supermarket'
                          ]
                              .map((type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              accountTypeName = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select an account type';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (validateUser()) {
                                authenticateUser(context);
                              }
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Color.fromARGB(255, 203, 152, 206),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }
}
// showAlertDialog(BuildContext context) {
//     // show the dialog
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               title:  Center(child: Text("Loading")),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                  Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               SizedBox(
//                                 height: 30.0,
//                               ),
//                               CircularProgressIndicator(
//                                 value: circularProgressVal,
//                                 strokeWidth: 6,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.indigo),
//                               ),
//                               SizedBox(
//                                 height: 30.0,
//                               ),
//                               Text("Account Creation...",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(fontSize: 16.0)
//                                       .copyWith(color: Colors.grey.shade900)),
//                             ],
//                           )],
//               ),
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(20.0))),
//             );
//           },
//         );
//       },
//     );
//   }