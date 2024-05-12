
//import 'package:caritas/splash.dart';
//import 'package:caritas/pages/login_page.dart';
//import 'package:caritas/splash.dart';
import 'package:caritas/home.dart';
//import 'package:caritas/splash.dart';
//import 'package:caritas/splash.dart';
import 'package:flutter/material.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: "Flutter Demo",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
 