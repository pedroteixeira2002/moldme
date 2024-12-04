import 'package:flutter/material.dart';

class AvailableProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Available Projects",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de Busca
            TextField(
              decoration: InputDecoration(
                hintText: "Search projects...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey.shade200,
                filled: true,
              ),
            ),
            SizedBox(height: 16),

            // Lista de Projetos
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Número de projetos
                itemBuilder: (context, index) {
                  return _buildProjectRow(
                    context: context,
                    title: "Project ${index + 1}",
                    date: "2023-12-${index + 10}",
                    status: index % 2 == 0 ? "Open" : "Closed",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectRow({
    required BuildContext context,
    required String title,
    required String date,
    required String status,
  }) {
    return GestureDetector(
      onTap: () {
        // Navegar para a página detalhada do projeto
        Navigator.pushNamed(context, '/public-project', arguments: {
          'title': title,
          'date': date,
          'status': status,
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Informações do Projeto
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Date: $date",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              // Status do Projeto
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: status == "Open"
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: status == "Open" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
