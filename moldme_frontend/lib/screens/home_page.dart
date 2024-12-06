import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/screens/company/payments_screen.dart';
import 'package:front_end_moldme/screens/public_profiles/company_public_screen.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/mappers/company_mapper.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar

class HomePageCompany extends StatefulWidget {
  final String currentUserId;

  const HomePageCompany({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _HomePageCompanyState createState() => _HomePageCompanyState();
}

class _HomePageCompanyState extends State<HomePageCompany>
    with SingleTickerProviderStateMixin {
  late Future<List<Company>> _companiesFuture;
  late TabController _tabController;
  final AuthenticationService _authenticationService = AuthenticationService();
  String? _role = '';

  @override
  void initState() {
    super.initState();
    _companiesFuture = _fetchCompanies();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserRole();
  }

  // Função para buscar e mapear as empresas
  Future<List<Company>> _fetchCompanies() async {
    final dtos = await CompanyService().listAllCompanies();
    return dtos.map((dto) => CompanyMapper.fromDto(dto)).toList();
  }
  // Função para carregar o papel do usuário
  Future<String> _loadUserRole() async {
    final role = await _authenticationService.checkRole();
    setState(() {
      _role = role;
    });
    print('Role: $_role');
    return role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(),
          Expanded(
            child: AppDrawer(
              userId: widget.currentUserId, // Verificar depois se está funcional
              companyId: "", 
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          
                                          // Passa o ID de qualquer empresa que está disponível na lista e abre a tela de perfil da empresa
                                          builder: (context) => CompanyProfileScreen(companyId: company.companyId!), 
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Aba de Pagamentos só para role Company
                        if (_role == 'Company') PaymentsScreen(companyId: widget.currentUserId),
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
