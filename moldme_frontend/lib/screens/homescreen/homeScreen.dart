import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 168, 226),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            _buildMainSection(),
            _buildWhyChooseUsSection(),
          ],
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and Title
          Row(
            children: [
              Image.asset('lib/images/logo.png', width: 50), // Placeholder for logo
              const SizedBox(width: 10),
              const Text(
                'MOLDME',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(38, 107, 181, 1.0),
                ),
              ),
            ],
          ),
          // Navigation Menu
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                 child: const Text("Sign in")),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("Sign up"),
              ),
              const SizedBox(width: 30),
              //IconButton(onPressed: () {}, icon: const Icon(Icons.facebook)),
              //IconButton(onPressed: () {}, icon: const Icon(Icons.instagram)),
            ],
          ),
        ],
      ),
    );
  }

  // Main Section
 Widget _buildMainSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20), // Espaçamento entre o cabeçalho e o texto
          const Text(
            "Transparency is key to progress!",
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 21, 65, 141), // Cor do texto alterada para azul mais escuro
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20), // Espaçamento entre o texto e a imagem
          Image.asset('lib/images/mainHomeScreen.png', 
          width: double.infinity,
          fit: BoxFit.cover,
            ), // Placeholder
        ],
      ),
    );
  }

  // Why Choose Us Section
  Widget _buildWhyChooseUsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "WHY CHOOSE US?",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFeatureCard(
                icon: Icons.attach_money,
                title: "Competitive Prices",
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              ),
              _buildFeatureCard(
                icon: Icons.security,
                title: "Secure Platform",
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              ),
              _buildFeatureCard(
                icon: Icons.explore,
                title: "Seamless Experience",
                description:
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Feature Card Widget
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 300, // Fixed width for consistency
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}