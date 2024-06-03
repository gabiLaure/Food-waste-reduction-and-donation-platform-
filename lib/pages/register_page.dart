// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, library_private_types_in_public_api

import 'package:caritas/pages/login_page.dart';
import 'package:caritas/widgets/custom_alert_dialog.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
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
  final ToastMessages _toastMessages = new ToastMessages();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _typeDeCompte = TextEditingController();

  String defaultUserAvatar =
      "https://firebasestorage.googleapis.com/v0/b/trashpick-db.appspot.com/o/Default%20User%20Avatar%2Ftrashpick_user_avatar.png?alt=media&token=734f7e74-2c98-4c27-b982-3ecd072ced79";

  bool _isHidden = true;

  double? circularProgressVal;
  bool isUserCreated = false;
  bool isAnError = false;

  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  String accountTypeName = 'Donor';
  int accountTypeID = 1;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  bool validateUser() {
    const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final RegExp regExp = RegExp(emailPattern);

    if (_firstNameController.text.isEmpty) {
      _toastMessages.showInfoToast("First Name is required");
      return false;
    } else if (_lastNameController.text.isEmpty) {
      _toastMessages.showInfoToast("Last Name is required");
      return false;
    } else if (_emailController.text.isEmpty) {
      _toastMessages.showInfoToast("Email is required");
      return false;
    } else if (!regExp.hasMatch(_emailController.text)) {
      _toastMessages.showInfoToast("Invalid Email Address");
      return false;
    } else if (_mobileController.text.isEmpty) {
      _toastMessages.showInfoToast("Mobile Number is required");
      return false;
    } else if (_password.text.isEmpty) {
      _toastMessages.showInfoToast("Password is required");
      return false;
    } else if (_typeDeCompte.text.isEmpty) {
      _toastMessages.showInfoToast("Account Type is required");
      return false;
    } else {
      return true;
    }
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CustomAlertDialog(
              isUserCreated: isUserCreated,
              isAnError: isAnError,
              firstName: _firstNameController.text,
              accountTypeName: accountTypeName,
              circularProgressVal: circularProgressVal,
            );
          },
        );
      },
    );
  }

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isUserCreated = false;
      isAnError = true;
      //Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  void authenticateUser() async {
    showAlertDialog(context);

    setState(() {
      isUserCreated = false;
      isAnError = false;
    });

    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: _emailController.text, password: _password.text);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        print('User Account Authenticated!');

        User? user = FirebaseAuth.instance.currentUser;

        if (!user!.emailVerified) {
          await user.sendEmailVerification();
          print('Verification Email Send!');
        }
        try {
          FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid.toString())
              .set({
            "uuid": FirebaseAuth.instance.currentUser!.uid.toString(),
            "accountType": accountTypeName,
            "firstName": _firstNameController.text,
            "lastName": _lastNameController.text,
            "email": _emailController.text,
            "contactNumber": _mobileController.text,
            'password': _password.text,
            'accountCreated': "$formattedDate, $formattedTime",
            'profileImage': defaultUserAvatar,
          }).then((value) {
            print("User Added to Firestore success");
            Navigator.pop(context);
            setState(() {
              isUserCreated = true;
              isAnError = false;
              showAlertDialog(context);
            });
          });
        } catch (e) {
          print("Failed to Add User to Firestore!: $e");
          ifAnError();
        }
      } else {
        print('Failed to User Account Authenticated!');
        ifAnError();
      }
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "[firebase_auth/email-already-in-use] Cet e-mail est déjà utilisé par un autre compte.") {
        ifAnError();
        ToastMessages().showErrorToast(
            "L\'adresse email est dejà utilisé par un autre compte");
      } else {
        ifAnError();
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/caritas_logo.png',
                width: 200,
                height: 200,
              ),
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  focusColor: Colors.grey[100],
                  hintText: 'First Name',
                  hintStyle: GoogleFonts.crimsonPro(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 14.0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        width: 0.2,
                      )),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 203, 152, 206),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  focusColor: Colors.grey[100],
                  hintText: 'Last Name',
                  hintStyle: GoogleFonts.crimsonPro(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 14.0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        width: 0.2,
                      )),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 203, 152, 206),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  focusColor: Colors.grey[100],
                  hintText: 'Email',
                  hintStyle: GoogleFonts.crimsonPro(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 14.0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        width: 0.2,
                      )),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 203, 152, 206),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _mobileController,
                decoration: InputDecoration(
                  focusColor: Colors.grey[100],
                  hintText: 'Mobile Number',
                  hintStyle: GoogleFonts.crimsonPro(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 14.0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        width: 0.2,
                      )),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 203, 152, 206),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  focusColor: Colors.grey[100],
                  hintText: 'Password',
                  hintStyle: GoogleFonts.crimsonPro(),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14.0,
                    horizontal: 14.0,
                  ),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        width: 0.2,
                      )),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 203, 152, 206),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // type de compte (donor, beneficiary) sous forme de dropdown dans un textfield
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: 'Account Type',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        width: 0.2,
                      )),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 203, 152, 206),
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                ),
                value: 'Orphanage',
                items: [
                  DropdownMenuItem(
                    child: Text('Orphanage'),
                    value: 'Orphanage',
                  ),
                  DropdownMenuItem(
                    child: Text('Restaurant'),
                    value: 'Restaurant',
                  ),
                  DropdownMenuItem(
                    child: Text('Superette'),
                    value: 'Grocery',
                  ),
                  DropdownMenuItem(
                    child: Text('Individual'),
                    value: 'Individual',
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    accountTypeName = value.toString();
                    _typeDeCompte.text = value.toString();
                  });
                },
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (validateUser()) {
                      authenticateUser();
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  },
                  child: const Text('Register',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 203, 152, 206),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      )),
                ),
              ),

              const SizedBox(height: 24),
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
      ),
    );
  }
}
