import 'package:flutter/material.dart';
import 'package:front_end_moldme/screens/company/payments_screen.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar
import 'package:front_end_moldme/widgets/project_list_widget.dart'; // Importa o widget da lista de projetos
import 'package:front_end_moldme/dtos/project_dto.dart'; // Certifique-se de importar os DTOs necessários
import 'package:front_end_moldme/services/project_service.dart'; // Para carregar os projetos


class HomePageCompany extends StatefulWidget {
  @override
  _HomePageCompanyState createState() => _HomePageCompanyState();
}

class _HomePageCompanyState extends State<HomePageCompany>
    with SingleTickerProviderStateMixin {
  late Future<List<ProjectDto>> _projectsFuture;
  late TabController _tabController;

  final String companyId = ""; // Company ID fixo (pode ser dinâmico)

  @override
  void initState() {
    super.initState();
    _projectsFuture = ProjectService()
        .listAllNewProjects(); // Carrega os projetos mais recentes
    _tabController =
        TabController(length: 2, vsync: this); // Controlador de abas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const CustomNavigationBar(), // Barra de navegação
          Expanded(
            child: AppDrawer(
              child: Column(
                children: [
                  // TabBar com duas abas: Projetos e Pagamentos
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: 'Projects'), // Aba para Projetos
                      Tab(text: 'Payments'), // Aba para Pagamentos
                    ],
                  ),
                  // TabBarView com os conteúdos para cada aba
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Aba de Projetos
                        FutureBuilder<List<ProjectDto>>(
                          future: _projectsFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text("Erro: ${snapshot.error}"));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text("Nenhum projeto disponível"));
                            }

                            List<ProjectDto> recentProjects =
                                snapshot.data!.take(3).toList();

                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey[100],
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "3 Projetos Mais Recentes",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 8),
                                    ProjectListWidget(
                                      projects: recentProjects,
                                      onProjectTap: (title, date, status) {
                                        Navigator.pushNamed(
                                            context, '/public-project',
                                            arguments: {
                                              'title': title,
                                              'date': date,
                                              'status': status,
                                            });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        // Aba de Pagamentos usando PaymentsScreen
                        PaymentsScreen(
                            companyId:
                                companyId), // Passando companyId para PaymentsScreen
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
