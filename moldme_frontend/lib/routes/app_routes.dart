import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/homescreen/homeScreen.dart';
import 'package:front_end_moldme/screens/register/loginScreen.dart';
import 'package:front_end_moldme/screens/register/recoverPasswordScreen.dart';
import 'package:front_end_moldme/screens/register/registerScreen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/' : (context) => const Homescreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/recoverPassword': (context) => RecoverPasswordScreen(),
  };
}