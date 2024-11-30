import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/project/new_project_screen.dart';
import 'package:front_end_moldme/screens/home/home_screen.dart';
import 'package:front_end_moldme/screens/project/project-page.dart';
import 'package:front_end_moldme/screens/project/project_proposal.dart';
import 'package:front_end_moldme/screens/settings/settings_screen.dart';

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
        '/new-project': (context) => const NewProjectPage(
              companyId: '',
            ),
        '/project-proposal': (context) => const ProjectScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/project-page': (context) => const ProjectPage(),
      },
    );
  }
}
