/*import 'dart:async';


import 'package:caritas/routes/route_manager.dart';
import 'package:flutter/material.dart';
import '../widgets/app_progress_indicator.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override

  //implement init stateto initialise app
  void initState(){
    //set timer before directing to the next Page
    Timer(
      //set time in seconds
      const Duration(seconds: 20), (){
    //go to the login page after 5 seconds of the loading page
        Navigator.popAndPushNamed(context, RouteManager.loginPage);
      }
    );
    super.initState();
  }

  @override
  
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blue,
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Loading Page",
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w300
          ),
          ),
            AppProgressIndicator(),
      ],),),
    );
  }
}*/