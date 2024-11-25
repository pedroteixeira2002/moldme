import 'package:flutter/material.dart';
import '../../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Center(
        child: const Text("Home"),
      ),
    );
  }
}
