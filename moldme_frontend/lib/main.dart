import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/new_project_screen.dart';
import 'package:front_end_moldme/screens/home_screen.dart';
import 'package:front_end_moldme/screens/project_screen.dart';
import 'package:front_end_moldme/screens/settings_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sidebar Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/new-project': (context) => const NewProjectScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/project': (context) => const ProjectPage(projectId: '',)
      },
    );
  }
  
}
