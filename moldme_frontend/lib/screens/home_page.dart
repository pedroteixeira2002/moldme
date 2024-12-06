import 'package:flutter/material.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class HomePageCompany extends StatelessWidget {
  final String userId;

  const HomePageCompany({super.key, required this.userId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(), // Adiciona a CustomNavigationBar no topo
          Expanded(
            child: AppDrawer(
              userId: userId, // Passa o userId para o AppDrawer
              companyId: '',
              child: const Center(
                child: Text(
                  "Bem-vindo à Home Page!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
