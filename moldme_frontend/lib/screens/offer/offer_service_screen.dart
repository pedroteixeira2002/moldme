import 'package:flutter/material.dart';

class OfferServiceScreen extends StatelessWidget {
  final String projectId;
  final String companyId;

  const OfferServiceScreen({
    super.key,
    required this.projectId,
    required this.companyId,
  });

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    return Scaffold(
      backgroundColor: Color(0xFFF6F9FF),
      appBar: AppBar(
        title: Text(
          "Propose Service",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Project ID: $projectId",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),

                // Campo de descrição
                TextFormField(
                  controller: descriptionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Proposal Description",
                    hintText: "Describe your proposal...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a description.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Campo de preço
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Proposed Price (\$)",
                    hintText: "Enter your price...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a price.";
                    }
                    if (double.tryParse(value) == null) {
                      return "Please enter a valid number.";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Botão de envio
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Simula o envio da proposta
                        Navigator.pushNamed(
                          context,
                          '/proposal-details',
                          arguments: {
                            'offerId':
                                'offer-${DateTime.now().millisecondsSinceEpoch}',
                            'companyId': companyId,
                            'projectId': projectId,
                            'description': descriptionController.text,
                            'price': priceController.text,
                            'date': DateTime.now().toString(),
                            'status': 'Pending',
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: Text("Submit Proposal"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
