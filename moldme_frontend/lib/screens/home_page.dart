import 'package:flutter/material.dart';
import 'app_drawer.dart'; // Certifique-se de que o caminho está correto.

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppDrawer(
      child: Center(
        child: Text(
          "Bem-vindo à Home Page!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
