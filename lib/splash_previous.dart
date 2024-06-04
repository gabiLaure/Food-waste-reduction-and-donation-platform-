import 'package:animated_splash_screen/animated_splash_screen.dart';
//import 'package:caritas/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'pages/login_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Scaffold(
        body: _buildUI(),
      ),
      nextScreen: LoginPage(),
      splashIconSize: 700,
    );
  }
}

Widget _buildUI() {
  return Center(
    child: LottieBuilder.asset("assets/animation/foody.json"),
  );
}
