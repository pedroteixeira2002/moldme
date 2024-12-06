import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/homescreen/homeScreen.dart';
import 'package:front_end_moldme/screens/public_profiles/employee_public_screen.dart';
import 'package:front_end_moldme/screens/register/loginScreen.dart';
import 'package:front_end_moldme/screens/register/recoverPasswordScreen.dart';
import 'package:front_end_moldme/screens/register/registerScreen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const Homescreen(),
    '/login': (context) => LoginScreen(),
    '/register': (context) => const RegisterScreen(),
    '/recoverPassword': (context) => RecoverPasswordScreen(),

    //Test routes
    '/employee-review': (context) => EmployeePublicScreen(
          employeeId: '7f4bfd06-9ec8-4409-9eda-0d7771cddd65',
        ),
  };
}
