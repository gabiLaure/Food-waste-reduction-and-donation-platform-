// ignore_for_file: prefer_const_constructors

import 'package:caritas/home.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAlertDialog extends StatelessWidget {
  final bool isUserCreated;
  final bool isAnError;
  final String firstName;
  final String accountTypeName;
  final double? circularProgressVal;

  const CustomAlertDialog(
      {super.key,
      required this.isUserCreated,
      required this.isAnError,
      required this.firstName,
      required this.accountTypeName,
      required this.circularProgressVal});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: !isUserCreated
          ? Center(child: Text("Creation du compte"))
          : Center(child: Text("Compte créé avec succès!")),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isUserCreated)
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
                        strokeWidth: 6,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.indigo),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text("Salut $firstName, Veuillez patienter...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 16.0)
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
                          text: "Réessayer",
                          textColor: Colors.white,
                          color: Colors.red,
                          onClicked: () {
                            Navigator.pop(context);
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
                      Get.offAll(HomePage());
                    }),
              ],
            ),
        ],
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
    );
  }
}
