import 'package:flutter/material.dart';
import '../screens/register/checkEmailScreen.dart';
import '../screens/register/loginScreen.dart';
import '../screens/register/recoverPasswordScreen.dart';
import '../screens/register/registerScreen.dart';
import '../screens/register/registerScreen2.dart';
import '../screens/register/planSelectionScreen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/' : (context) => const RecoverPasswordScreen(),
    '/login': (context) => const LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/register2': (context) => const RegisterScreen2(),
    '/planSelection': (context) => const PlanSelectionScreen(),
    '/checkEmail': (context) => const CheckEmailScreen(),
    '/recoverPassword': (context) => const RecoverPasswordScreen(),
  };
}