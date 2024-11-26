import 'package:caritas/home.dart';
import 'package:caritas/pages/Restaurant/restaurant_registration_page.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../admin/models/global_data.dart';
import '../../widgets/forgot_password_page.dart';
import '../Orphanage/orphanage_registration_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ToastMessages _toastMessages = new ToastMessages();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isUserSigned = false;
  bool isInValidaAccount = false;
  double? circularProgressVal;
  late String accountType;

  showAlertDialog(BuildContext context) {
    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: !isUserSigned
                  ? Center(child: Text("Connect"))
                  : Center(child: Text("Welcome back!")),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isUserSigned)
                    !isInValidaAccount
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 30.0,
                              ),
                              CircularProgressIndicator(
                                value: circularProgressVal,
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.indigo),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text("Connexion to your account...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Error!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              ButtonWidget(
                                  text: "Try again",
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  onClicked: () {
                                    setState(() {
                                      isUserSigned = false;
                                      isInValidaAccount = false;
                                      Navigator.pop(context);
                                    });
                                  }),
                            ],
                          )
                  else
                    Column(
                      children: [
                        Text("Welcome!",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            )),
                        SizedBox(
                          height: 50.0,
                        ),
                        Image.asset(
                          'assets/images/welcome.png',
                          height: 100,
                          width: 100,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        ButtonWidget(
                            text: "Continue",
                            textColor: Colors.white,
                            color: Colors.indigo,
                            onClicked: () {
                              Navigator.pop(context);
                            }),
                      ],
                    ),
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

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isUserSigned = false;
      isInValidaAccount = true;
      //Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  bool validateUser() {
    const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regExp = RegExp(pattern);

    if (_usernameController.text.isEmpty && _passwordController.text.isEmpty) {
      _toastMessages.showInfoToast('Veuillez remplir les informations');
    } else if (_usernameController.text.isEmpty) {
      _toastMessages.showInfoToast('L\'email est vide');
    } else if (!regExp.hasMatch(_usernameController.text)) {
      _toastMessages.showInfoToast('Format de l\'email non respecté');
    } else if (_usernameController.text.isEmpty) {
      _toastMessages.showInfoToast('Mot de passe vide');
    } else {
      print('Validation Success!');
      return true;
    }

    return false;
  }

  void _signInWithEmailAndPassword(context) async {
    // showAlertDialog(context);

    setState(() {
      isUserSigned = false;
      isInValidaAccount = false;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _usernameController.text,
              password: _passwordController.text);
      // Récupération du document basé sur l'UID
      String userUid = userCredential.user!.uid.toString();

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userUid) // Utilisation de l'UID
          .get();
      if (userDoc.exists) {
        // Affichage des données du document
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;
        getUserSupInfo(userData);
      } else {
        _toastMessages.showErrorToast("An error occured.");
      }

      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => HomePage(),
      //   ),
      //   (route) => false,
      // );
      // Navigator.pop(context);
      // print('User is signed in!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ifAnError();
        _toastMessages.showErrorToast("No user found");
      } else if (e.code == 'wrong-password') {
        ifAnError();
        _toastMessages.showErrorToast("Incorrect password!");
      } else {
        _toastMessages.showErrorToast("An error has occured.");
        _toastMessages.showErrorToast(e.toString());
      }
    }
  }

  void getUserSupInfo(userData) {
    // Navigate based on account type
    GlobalData.userData = userData;
    switch (userData['accountType']) {
      case 'Orphanage':
        fetchOrphanageByUserProfileID(userData);
        break;
      case 'Restaurant':
        fetchRestaurantByUserProfileID(userData);
        break;

      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        return;
    }
  }

  void fetchOrphanageByUserProfileID(userProfile) async {
    try {
      // Query Firestore to find the orphanage with the given userProfileID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .where('userProfileID', isEqualTo: userProfileID)
          .get();
      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming userProfileID is unique)
        DocumentSnapshot document = querySnapshot.docs.first;

        Map<String, dynamic> orphanageData = {
          ...document.data() as Map<String, dynamic>,
          'id': document.id, // Add the document ID
        };

        // Use the orphanage data as needed
        GlobalData.orphanageData = orphanageData;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Orphanage found'),
            content: Text(
                "We can't get an Orphanage related to this account though it has an account type Orphanage. Please register ophanage on this account!"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrphanageRegistration()),
                    );
                  },
                  child: const Text('OK'))
            ],
          ),
        );
      }
    } catch (e) {
      print('Error fetching orphanage: $e');
    }
  }

  void fetchRestaurantByUserProfileID(userProfile) async {
    try {
      // Query Firestore to find the orphanage with the given userProfileID
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('restaurants')
          .where('userProfileID', isEqualTo: userProfileID)
          .get();
      // Check if any documents are returned
      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document (assuming userProfileID is unique)
        DocumentSnapshot document = querySnapshot.docs.first;

        Map<String, dynamic> orphanageData = {
          ...document.data() as Map<String, dynamic>,
          'id': document.id, // Add the document ID
        };

        // Use the orphanage data as needed
        GlobalData.orphanageData = orphanageData;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('No Restaurant found'),
            content: Text(
                "We can't get an Restaurant related to this account though it has an account type Restaurant. Please register restaurant on this account!"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RestaurantRegistration()),
                    );
                  },
                  child: const Text('OK'))
            ],
          ),
        );
      }
    } catch (e) {
      print('Error fetching orphanage: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50.0, left: 16, right: 16),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/caritas_logo.png',
                  width: 200,
                  height: 200,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    focusColor: Colors.grey[100],
                    hintText: 'Username or phone',
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
                  controller: _passwordController,
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (validateUser()) {
                        _signInWithEmailAndPassword(context);
                      }
                    },
                    child: Text('Login',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 203, 152, 206),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to the registration page when "Register" is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegistrationPage()),
                          );
                        },
                        child: const Text("Don't have an account? Register"),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          // Navigate to the forgot password page when "Forgot Password" is pressed
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordPage()),
                          );
                        },
                        child: const Text("Forgot Password?"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
