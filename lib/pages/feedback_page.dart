// ignore_for_file: unnecessary_new, prefer_const_constructors

import 'package:caritas/generators/uuid_generator.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GiveFeedbackPage extends StatefulWidget {
  @override
  _GiveFeedbackPageState createState() => _GiveFeedbackPageState();
}

class _GiveFeedbackPageState extends State<GiveFeedbackPage> {
  TextEditingController _giveFeedbackController = new TextEditingController();
  int charLength = 0;
  String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String formattedTime = DateFormat('kk:mm:a').format(DateTime.now());

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  late double circularProgressVal;

  _onChanged(String value) {
    setState(() {
      charLength = value.length;
    });
  }

  // -------------------------------- UPLOADING PROCESS -------------------------------- \\

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isStartToUpload = false;
      isUploadComplete = false;
      isAnError = true;
      //Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  void sendErrorCode(String error) {
    ToastMessages().showErrorToast(error);
    ifAnError();
  }

  void sendSuccessCode() {
    print("Commentaire envoyé avec succès!");
    Navigator.pop(context);
    setState(() {
      isStartToUpload = false;
      isUploadComplete = true;
    });
    showAlertDialog(context);
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
              title: !isUploadComplete
                  ? Center(child: Text("Envoi du Commentaire"))
                  : Center(child: Text("Commentaire Envoyé avec Succès!")),
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
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.teal.shade700),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                  "Veuillez patienter jusqu'à l'envoi de vos commentaires.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 16.0)
                                      .copyWith(color: Colors.grey.shade900)),
                            ],
                          )
                        : Column(
                            children: [
                              Text("Erreur!",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  )),
                              SizedBox(
                                height: 50.0,
                              ),
                              ButtonWidget(
                                  text: "Réessayez",
                                  textColor: Colors.white,
                                  color: Colors.indigo,
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
                            Text("Commentaire envoyé avec succès",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22.0)
                                    .copyWith(
                                        color: Colors.grey.shade900,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(height: 50),
                            ButtonWidget(
                              textColor: Colors.white,
                              color: Colors.indigo,
                              text: "OK",
                              onClicked: () {
                                Navigator.pop(context);
                              },
                            )
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

  sendFeedback() {
    FirebaseFirestore.instance
        .collection('Feedbacks')
        .doc("User Feedbacks")
        .collection(FirebaseAuth.instance.currentUser!.uid)
        .doc(UUIDGenerator().uuidV1())
        .set({
          'feedback': _giveFeedbackController.text,
          'postedDate': "$formattedDate, $formattedTime",
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  void validateEdits() {
    if (_giveFeedbackController.text.isEmpty) {
      ToastMessages().showWarningToast("Veuillez saisir votre commentaire");
    } else {
      print(_giveFeedbackController.text);
      sendFeedback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faire un Commentaire"),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20.0,
          ),
          Image.asset(
            'assets/caritas_logo.png',
            height: 150.0,
            width: 150.0,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextFormField(
              controller: _giveFeedbackController,
              style: TextStyle(fontWeight: FontWeight.normal),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 10.0),
                helperText: "N° de lettres: $charLength",
                hintText: "Dites quelque chose...",
                labelText: 'Taper votre Commentaire',
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ),
                ),
                labelStyle: TextStyle(
                    color: Colors.grey.shade900, fontWeight: FontWeight.bold),
              ),
              onChanged: _onChanged,
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton(
              child: Text("Envoyer votre Commentaire"),
              onPressed: () {
                validateEdits();
              },
            ),
          ),
        ],
      ),
    );
  }
}
