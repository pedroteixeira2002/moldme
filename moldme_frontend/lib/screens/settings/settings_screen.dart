import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Center(
        child: const Text("Project details will go here."),
      ),
    );
  }
}
