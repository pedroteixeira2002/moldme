import 'package:flutter/material.dart';

class OfferProposalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String offerId = arguments['offerId'];
    final String companyId = arguments['companyId'];
    final String projectId = arguments['projectId'];
    final String description = arguments['description'];
    final String price = arguments['price'];
    final String date = arguments['date'];
    final String status = arguments['status'];

    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      appBar: AppBar(
        title: Text(
          "Proposal Details",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Offer ID: $offerId",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              "Project ID: $projectId",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),

            Text(
              "Company ID: $companyId",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Descrição da proposta
            Text(
              "Proposal Description:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
            SizedBox(height: 16),

            // Preço da proposta
            Text(
              "Proposed Price:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "\$$price",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
            SizedBox(height: 16),

            // Data da proposta
            Text(
              "Date Submitted:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              date,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
            ),
            SizedBox(height: 16),

            // Status da proposta
            Text(
              "Status:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              status,
              style: TextStyle(
                fontSize: 14,
                color: status == "Accepted"
                    ? Colors.green
                    : status == "Rejected"
                        ? Colors.red
                        : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
