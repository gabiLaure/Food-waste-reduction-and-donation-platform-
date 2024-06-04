import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  get splash => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Image.asset(
          'assets/caritas_logo.png',
          width: 800,
          height: 800,
        ),
        //backgroundColor: Color.fromARGB(255, 236, 183, 239),

        //Color(RGBA(32,159,166,255))
        splashTransition: SplashTransition.scaleTransition,
        nextScreen: OnBoardingScreen());
  }
}
