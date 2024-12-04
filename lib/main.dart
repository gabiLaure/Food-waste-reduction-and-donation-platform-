// ignore_for_file: prefer_const_constructors

// import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/admin/models/global_data.dart';
import 'package:caritas/home.dart';
import 'package:caritas/intro/screens/splash.dart';
import 'package:caritas/pages/Registration/login_page.dart';
import 'package:caritas/pages/Registration/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final user = GlobalData.userData;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GlobalData.loadFromLocalStorage();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> hasUserAccessedSplash() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasAccessedSplash') ??
        false; // Return false if the value doesn't exist
  }

  // @override
  // Widget build(BuildContext context) {
  //    bool hasAccessed = await hasUserAccessedSplash();
  //   return GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     title: "Flutter Demo",
  //     theme: ThemeData(
  //       textTheme: GoogleFonts.crimsonProTextTheme(
  //         Theme.of(context).textTheme,
  //       ),
  //       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //       useMaterial3: true,
  //     ),

  //     //home: HomePage(),
  //     //home: SplashScreen(),
  //     home :  await hasUserAccessedSplash() ? user ? HomePage() : LoginPage() : SplashScreen();
  //     // home: user == null ? SplashScreen() : HomePage(),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: hasUserAccessedSplash(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        // Check if data is still loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // Check if there is an error
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading app"));
        }

        // Data loaded, show the appropriate screen
        bool hasAccessed = snapshot.data ?? false;

        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Flutter Demo",
            theme: ThemeData(
              textTheme: GoogleFonts.crimsonProTextTheme(
                Theme.of(context).textTheme,
              ),
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            // home: hasAccessed
            //     ? (user != null ? HomePage() : LoginPage())
            //     : const SplashScreen(),
            home: LoginPage()
            //home: RegistrationPage()
            );
      },
    );
  }
}
