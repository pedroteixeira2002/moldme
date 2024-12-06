import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/screens/company/payments_screen.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/mappers/company_mapper.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class HomePageCompany extends StatefulWidget {
  @override
  _HomePageCompanyState createState() => _HomePageCompanyState();
}

class _HomePageCompanyState extends State<HomePageCompany>
    with SingleTickerProviderStateMixin {
  late Future<List<Company>> _companiesFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _companiesFuture = _fetchCompanies();
    _tabController = TabController(length: 2, vsync: this);
  }

  // Função para buscar e mapear as empresas
  Future<List<Company>> _fetchCompanies() async {
    final dtos = await CompanyService().listAllCompanies();
    return dtos.map((dto) => CompanyMapper.fromDto(dto)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(),
          Expanded(
            child: AppDrawer(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Companies'),
                      Tab(text: 'Payments'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Aba de Empresas
                        FutureBuilder<List<Company>>(
                          future: _companiesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error: ${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("No companies available"));
                            }

                            final companies = snapshot.data!;
                            return ListView.builder(
                              itemCount: companies.length,
                              itemBuilder: (context, index) {
                                final company = companies[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 16),
                                  child: ListTile(
                                    title: Text(company.name),
                                    subtitle: Text(company.email),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/company-profile',
                                        arguments: company.companyId,
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Aba de Pagamentos (manter como está)
                        PaymentsScreen(
                            companyId: 'fb467816-7ce9-4d8a-9acd-646ecda29bc3'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
