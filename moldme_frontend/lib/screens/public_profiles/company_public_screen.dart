import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class CompanyProfileScreen extends StatelessWidget {
  final String companyId;

  // Construtor para aceitar o companyId
  const CompanyProfileScreen({required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(), // Adiciona a CustomNavigationBar no topo
          Expanded(
            child: AppDrawer(
              child: FutureBuilder<CompanyDto>(
                future: CompanyService().getCompanyById(companyId),
                builder: (context, snapshot) {
                  // Todo o código original permanece aqui
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Loading..."),
                      ),
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Error"),
                      ),
                      body: Center(
                        child: Text('Error: ${snapshot.error}'),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text("Not Found"),
                      ),
                      body: const Center(
                        child: Text('Company not found'),
                      ),
                    );
                  }

                  final company = snapshot.data!;
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(company.name),
                    ),
                    backgroundColor: const Color(0xFFF6F9FF),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner da Empresa
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 250,
                                color: Colors.blue.shade200,
                                child: Center(
                                  child: Text(
                                    company.name.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Informações da Empresa
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors
                                      .blue.shade100, // Cor padrão para o logo
                                  child: const Icon(
                                    Icons.business,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        company.name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        company.sector,
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(company.address ??
                                              'No address available'),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(Icons.email,
                                              size: 16, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(company.email),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Informações Detalhadas
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(
                              "Details:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow(
                                    "Tax ID", company.taxId.toString()),
                                _buildDetailRow(
                                    "Contact", company.contact.toString()),
                                _buildDetailRow("Sector", company.sector),
                                _buildDetailRow(
                                    "Plan", company.plan.toString()),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
