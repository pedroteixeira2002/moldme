import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/mappers/company_mapper.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class AvailableCompaniesScreen extends StatefulWidget {
  @override
  _AvailableCompaniesScreenState createState() =>
      _AvailableCompaniesScreenState();
}

class _AvailableCompaniesScreenState extends State<AvailableCompaniesScreen> {
  late Future<List<Company>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _companiesFuture = _fetchCompanies();
  }

  // Função para buscar e mapear as empresas
  Future<List<Company>> _fetchCompanies() async {
    // Busca as empresas como DTOs
    final dtos = await CompanyService().listAllCompanies();
    // Converte os DTOs para o modelo Company
    return dtos.map((dto) => CompanyMapper.fromDto(dto)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(), // Adiciona a CustomNavigationBar no topo
          Expanded(
            child: AppDrawer(
              child: Scaffold(
                backgroundColor: const Color(0xFFF6F9FF),
                body: FutureBuilder<List<Company>>(
                  future: _companiesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No companies available"));
                    }

                    final companies = snapshot.data!;
                    return ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        final company = companies[index];
                        return ListTile(
                          title: Text(company.name),
                          subtitle: Text(company.email),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/company-profile',
                              arguments: company.companyId,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
