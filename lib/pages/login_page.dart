// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, avoid_print, use_build_context_synchronously

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

import 'package:caritas/home.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ToastMessages _toastMessages = new ToastMessages();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isHidden = true;
  bool isUserSigned = false;
  bool isInValidaAccount = false;
  double? circularProgressVal;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late String accountType;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

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
                  ? Center(child: Text("Se connecter"))
                  : Center(child: Text("Bienvenue à nouveau!")),
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
                              Text("Connexion à votre compte...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Erreur!",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              ButtonWidget(
                                  text: "Réessayez",
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
                        Text("Bienvenue!",
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
                            text: "Continuer",
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

  void _signInWithEmailAndPassword() async {
    showAlertDialog(context);

    setState(() {
      isUserSigned = false;
      isInValidaAccount = false;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _usernameController.text,
              password: _passwordController.text);
      print(userCredential.user!.uid.toString());
      // await geAccountType(userCredential.user!.uid.toString());
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
        (route) => false,
      );
      //Navigator.pop(context);
      print('User is signed in!');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ifAnError();
        print('No user found for that email.');
        _toastMessages.showErrorToast("Pas d'utilisateur trouvé");
      } else if (e.code == 'wrong-password') {
        ifAnError();
        print('Wrong password provided for that user.');
        _toastMessages.showErrorToast("Mot de passe incorrect!");
      } else {
        _toastMessages.showErrorToast("Une erreur est survenue.");
        _toastMessages.showErrorToast(e.toString());
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                    _signInWithEmailAndPassword();
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
                            builder: (context) => const RegisterPage()),
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
                            builder: (context) => const ForgotPasswordPage()),
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
    );
  }
}
