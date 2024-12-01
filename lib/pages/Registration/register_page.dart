import 'package:caritas/admin/models/global_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../home.dart';
import '../../widgets/button_widgets.dart';
import '../../widgets/toast_messages.dart';
import '../Orphanage/orphanage_registration_page.dart';
import '../Restaurant/restaurant_registration_page.dart';
import '../Supermarket/supermarket_registration.dart';

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

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double? circularProgressVal;

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isUploadComplete
                  ? Center(child: Text("Registration Loading"))
                  : Center(child: Text("Loading completed")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUploadComplete)
                    !isAnError
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              CircularProgressIndicator(
                                value: circularProgressVal,
                                strokeWidth: 5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal.shade700),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text("Please your account is been created...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Error!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              ButtonWidget(
                                  text: "Try Again",
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  onClicked: () {
                                    Navigator.pop(context);
                                  }),
                            ],
                          )
                  else
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/welcome.png',
                              height: 50,
                              width: 50,
                            ),
                            SizedBox(height: 30),
                            Text("The Account has been charged!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0)
                                    .copyWith(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            ButtonWidget(
                                text: "Continue",
                                textColor: Colors.white,
                                color: Colors.indigo,
                                onClicked: () {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                }),
                          ],
                        ),
                      ),
                    )
                ],
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
            );
          },
        );
      },
    );
  }

  // Validation function to check if inputs are valid
  bool validateUser() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.5;
      });
      showAlertDialog(context);
    }
    return true;
  }

  void showMessageError() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isStartToUpload = true;
        circularProgressVal = 0.5;
      });
      showAlertDialog(context);
    }
  }

  // Authenticate user with Firebase Auth
  void authenticateUser(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email and password cannot be empty')),
      );
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      final userInfos = {
        'userUid': userCredential.user!.uid.toString(),
        'fullname': fullNameController.text.trim(),
        'phone': phoneController.text.trim(),
        'accountType': accountTypeName,
        'email': emailController.text.trim()
      };
      // add user to firestore with multiple images
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.uid.toString())
          .set(userInfos)
          .then(
            (value) => redirectUser(context, userInfos),
          )
          .catchError((error) => sendErrorCode(error.toString()));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      Navigator.pop(context);
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Email already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = 'Registration failed. Please try again.';
      }
      switch (e.code) {
        case 'email-already-in-use':
          ToastMessages().showErrorToast('Email already in use.');
          break;
        case 'weak-password':
          ToastMessages().showErrorToast('The password is too weak.');
          break;
        default:
          ToastMessages()
              .showErrorToast('Registration failed. Please try again.');
          break;
      }

      ToastMessages().showErrorToast(errorMessage);
    } catch (e) {
      ToastMessages().showErrorToast('Registration failed: $e');
    }
  }

  void sendErrorCode(error) {
    Navigator.pop(context);
    ToastMessages().showErrorToast(error);
  }

  void redirectUser(context, user) {
    GlobalData.userData = user;
    // Navigate based on account type
    switch (accountTypeName) {
      case 'Individual':
        ToastMessages().showSuccessToast('Your User Account has been created');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 'Orphanage':
        ToastMessages().showSuccessToast(
          'Your User account has been created, please fill the Orphanage Registration form',
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrphanageRegistration()),
        );
        break;
      case 'Restaurant':
        ToastMessages().showSuccessToast(
          'Your User account has been created please fill the Restaurant Registration form',
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => RestaurantRegistration()));
        break;
      case 'Supermarket':
        ToastMessages().showSuccessToast(
            'Your User account has been created please fill the Supermarket Registration form');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SupermarketRegistration()),
        );
        break;
      default:
        ToastMessages().showErrorToast('Invalid account type');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RegistrationPage()),
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
                            child: Text(
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
