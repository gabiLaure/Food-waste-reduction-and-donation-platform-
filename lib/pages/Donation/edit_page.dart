// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:caritas/models/user_model.dart';
import 'package:caritas/widgets/button_widgets.dart';
import 'package:caritas/widgets/image_frames_widgets.dart';
import 'package:caritas/widgets/toast_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:image_picker/image_picker.dart';

class EditDonorProfilePage extends StatefulWidget {
  @override
  _EditDonorProfilePageState createState() => _EditDonorProfilePageState();
}

class _EditDonorProfilePageState extends State<EditDonorProfilePage> {
  String currentUserID = FirebaseAuth.instance.currentUser!.uid.toString();
  late CollectionReference imgRef;
  late firebase_storage.Reference ref;
  File? _userSelectedFileImage;
  late String firebaseStorageUploadedImageURL;
  late String _userLatestProfileImage;

  // Uploading Process
  bool isStartToUpload = false;
  bool isUploadComplete = false;
  bool isAnError = false;
  double? circularProgressVal;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController interestsController = TextEditingController();

  void ifAnError() {
    Navigator.pop(context);
    setState(() {
      isStartToUpload = false;
      //isUploadComplete = false;
      isUploadComplete = true;
      isAnError = true;
      //Navigator.pop(context);
      showAlertDialog(context);
    });
  }

  void sendErrorCode(String error) {
    ToastMessages().showErrorToast(
      error,
    );
    ifAnError();
  }

  void sendSuccessCode() {
    print("Profile Update Success!");
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
                  ? Center(child: Text("Mise à jour du profil"))
                  : Center(child: Text("Profil mis à jour")),
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
                              Text("Veuillez patienter...",
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
                                  text: "Réessayer",
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
                            Text("Profile mis à jour avec succès",
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

  void validateEdits() {
    if (_userSelectedFileImage == null) {
      ToastMessages().showErrorToast("Veuillez selectionner une image");
    } else {
      showAlertDialog(context);
      uploadImagesToStorage();
    }
  }

  _imgFromCamera() async {
    XFile? fileImage = (await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _userSelectedFileImage = File(fileImage!.path);
    });
  }

  _imgFromGallery() async {
    XFile? fileImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (fileImage != null) {
      setState(() {
        _userSelectedFileImage = File(fileImage.path);
      });
    }
  }
  // _imgFromGallery() async {
  //   XFile? fileImage = (await ImagePicker()
  //       .pickImage(source: ImageSource.gallery, imageQuality: 50));

  //   setState(() {
  //     _userSelectedFileImage = File(fileImage!.path);
  //   });
  // }

  changeProfilePicture(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Phototèque'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> uploadImagesToStorage() async {
    if (_userSelectedFileImage != null) {
      FirebaseStorage.instance.refFromURL(_userLatestProfileImage).delete();

      try {
        ref = firebase_storage.FirebaseStorage.instance.ref().child(
            'User Profile Images/${FirebaseAuth.instance.currentUser?.uid}/${FirebaseAuth.instance.currentUser?.uid}');
        await ref.putFile(_userSelectedFileImage!);

        String downloadURL = await firebase_storage.FirebaseStorage.instance
            .ref()
            .child(
                'User Profile Images/${FirebaseAuth.instance.currentUser?.uid}/${FirebaseAuth.instance.currentUser?.uid}')
            .getDownloadURL();
        firebaseStorageUploadedImageURL = downloadURL.toString();
        print("Image Uploaded to Firebase Storage!");
        print("Image URL: " + firebaseStorageUploadedImageURL);
        saveEditProfileToFireStore(firebaseStorageUploadedImageURL);
      } catch (e) {
        print(e.toString());
        ifAnError();
      }
    } else {
      saveEditProfileToFireStore(_userLatestProfileImage);
    }
  }

  saveEditProfileToFireStore(String firebaseStorageUploadedImageURL) {
    print("IMAGE: " + firebaseStorageUploadedImageURL);

    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID.toString())
        .update({
          'profileImage': firebaseStorageUploadedImageURL,
        })
        .then(
          (value) => sendSuccessCode(),
        )
        .catchError((error) => sendErrorCode(error.toString()));
  }

  Future<void> updateProfile(UserModelClass userModel, String userId) async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .set(userModel.toDocument())
        .then((value) => sendSuccessCode())
        .catchError((error) => sendErrorCode(error.toString()));
    // .whenComplete(() => ToastMessages().showSuccessToast("Profil mis à jour"));
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Donor Profile'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where('uuid', isEqualTo: currentUserID.toString())
                    .snapshots(),
                builder: (context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    UserModelClass userModelClass =
                        UserModelClass.fromDocument(dataSnapshot.data!.docs[0]);

                    _userLatestProfileImage = userModelClass.profileImage;
                    return ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 5.0,
                          ),
                          Center(
                            child: _userSelectedFileImage != null
                                ? ImageFramesWidgets().userProfileFrame(
                                    _userSelectedFileImage, 150.0, 65.0, false)
                                : ImageFramesWidgets().userProfileFrame(
                                    _userLatestProfileImage, 150.0, 65.0, true),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: TextWithIconButtonWidget(
                              text: "Cliquer pour changer l'image",
                              icon: Icons.camera_alt_rounded,
                              iconToLeft: true,
                              onClicked: () {
                                print('Change Profile Image');
                                changeProfilePicture(context);
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller: firstNameController
                              ..text = userModelClass.firstName,
                            decoration:
                                InputDecoration(labelText: 'First Name'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller: lastNameController
                              ..text = userModelClass.lastName,
                            decoration: InputDecoration(labelText: 'Last Name'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller: emailController
                              ..text = userModelClass.email,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller: phoneNumberController
                              ..text = userModelClass.contactNumber,
                            decoration:
                                InputDecoration(labelText: 'Phone Number'),
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            readOnly: true,
                            controller: accountTypeController
                              ..text = userModelClass.accountType,
                            decoration:
                                InputDecoration(labelText: 'Account Type'),
                          ),
                          // SizedBox(height: 16),
                          // TextFormField(
                          //   controller: addressController,
                          //   decoration: InputDecoration(labelText: 'Address'),
                          // ),
                          // SizedBox(height: 16),
                          // TextFormField(
                          //   controller: interestsController,
                          //   decoration: InputDecoration(labelText: 'Interests'),
                          // ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              validateEdits();
                              //updateProfile(userModelClass, currentUserID);
                              // Save changes logic (update donor data)
                              // final updatedFullName = fullNameController.text;
                              // final updatedEmail = emailController.text;
                              // final updatedAddress = addressController.text;
                              // final updatedInterests = interestsController.text;

                              // Implement your logic to save changes to the donor profile
                              // (e.g., update database, API call, etc.)

                              // Show a confirmation message
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(
                              //       content: Text('Profile updated successfully!')),
                              // );
                            },
                            child: Text('Save Changes'),
                          ),
                        ]);
                  }
                })));
  }
}
