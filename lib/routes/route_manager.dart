/*import 'package:flutter/material.dart';

import '../pages/loading_page.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';

class RouteManager{
  static const String loadingPage ='/';
  static const String loginPage = '/loginPage';
  static const String registerPage = 'registerPage';

  static Route<dynamic>? onGenerteRoute(RouteSettings settings){
    switch(settings.name){

      case loadingPage:
      return MaterialPageRoute(
        builder: (context) => const LoadingPage(),
        );

        case loginPage:
      return MaterialPageRoute(
        builder: (context) => const LoginPage(),
        );

        case registerPage:
      return MaterialPageRoute(
        builder: (context) => const RegisterPage(),
        );

        default:
          throw Exception("No route found!");
    }
  }

  static onGenerateRoute() {} 

}*/