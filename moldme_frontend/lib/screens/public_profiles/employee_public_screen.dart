import 'package:flutter/material.dart';

class EmployeePublicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de Fundo
            Stack(
              children: [
                Image.network(
                  'https://via.placeholder.com/1200x400', // Placeholder para o banner
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Icon(Icons.facebook, color: Colors.white),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
              ],
            ),

            // Informações do Funcionário
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // Placeholder para foto de perfil
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Raghu Simon",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Incoe Corporation",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Colors.grey),
                            SizedBox(width: 4),
                            Text("Jakarta Selatan, Indonesia"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Descrição do Funcionário
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Get To Know:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "INCOE designs and manufactures hot runner systems driven by performance for the processing of all injection moldable plastic materials. A leader and pioneer in the plastics industry, our original patented design was the first commercial hot runner nozzle available. The development and use of hot runner systems has led to the advancement of injection molding on a global basis. By design, the hot runner system has been eco-friendly since inception with reduced material use and waste by-product.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
              ),
            ),

            // Avaliações do Funcionário
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Employee Reviews",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "4.7",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 32),
                        Icon(Icons.star, color: Colors.amber, size: 32),
                        Icon(Icons.star, color: Colors.amber, size: 32),
                        Icon(Icons.star, color: Colors.amber, size: 32),
                        Icon(Icons.star_half, color: Colors.amber, size: 32),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      "(578 Reviews)",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    SizedBox(height: 16),
                    _buildReviewRow("5 stars", 488),
                    _buildReviewRow("4 stars", 74),
                    _buildReviewRow("3 stars", 14),
                    _buildReviewRow("2 stars", 0),
                    _buildReviewRow("1 star", 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: Colors.grey.shade800)),
          ),
          Expanded(
            flex: 6,
            child: LinearProgressIndicator(
              value: count / 500,
              backgroundColor: Colors.grey.shade300,
              color: Colors.amber,
            ),
          ),
          SizedBox(width: 8),
          Text(
            count.toString(),
            style: TextStyle(color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }
}
