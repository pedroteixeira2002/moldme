import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/status.dart';
import 'package:front_end_moldme/screens/project/edit_project.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/widgets/chat_card.dart';
import 'package:front_end_moldme/widgets/employe_add.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';
import 'package:front_end_moldme/widgets/task_new_card.dart';
import 'package:front_end_moldme/widgets/team_project.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/screens/project/project_tasks_screen.dart';

void main() {
  runApp(const MaterialApp(
      home: ProjectPage(
    companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498',
    projectId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
    currentUserId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
  )));
}

class ProjectPage extends StatefulWidget {
  final String companyId; // ID da empresa
  final String projectId; // ID do projeto
  final String currentUserId; // ID do usuário atual

  const ProjectPage({super.key, required this.companyId, required this.projectId, required this.currentUserId});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  final ProjectService _projectService =
      ProjectService(); // Instância do serviço
  bool _showEmployeeList =
      false; // Controle de exibição da lista de funcionários
  ProjectDto? _project; // Detalhes do projeto
  final bool _isLoading = true; // Controle de carregamento
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchProjectDetails(); // Busca os detalhes do projeto ao carregar a página
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Método para buscar os detalhes do projeto usando projectView
  Future<void> _fetchProjectDetails() async {
    try {
      final project = await _projectService.projectView(
        widget.companyId,
        widget.projectId,
      );
      setState(() {
        _project = project; // Define os detalhes do projeto no estado
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch project details: $e")),
      );
    }
  }

  String _statusToString(int status) {
    switch (Status.fromInt(status)) {
      case Status.newEntity:
        return "New";
      case Status.inProgress:
        return "In Progress";
      case Status.done:
        return "Done";
      case Status.closed:
        return "Closed";
      case Status.canceled:
        return "Canceled";
      case Status.pending:
        return "Pending";
      case Status.accepted:
        return "Accepted";
      case Status.denied:
        return "Denied";
      default:
        return "Unknown";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNavigationBar(), // Usa a nova AppBar
      body: AppDrawer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Tasks'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Verifica se os detalhes do projeto foram carregados
                          if (_project != null) ...[
                            // Título com o nome do projeto
                            Text(
                              _project!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Descrição do projeto
                            Text(
                              _project!.description,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Datas de início e fim do projeto
                            Text(
                              "Start Date: ${_project!.startDate.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "End Date: ${_project!.endDate.toLocal().toString().split(' ')[0]}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              "Status: ${_statusToString(_project!.status)}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 16),
                          ] else
                            // Indicador de carregamento enquanto os detalhes do projeto são buscados
                            const Center(child: CircularProgressIndicator()),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProjectPage(
                                      projectId: widget.projectId),
                                ),
                              ).then((value) {
                                if (value == true) {
                                  _fetchProjectDetails(); // Recarrega os detalhes do projeto após a edição
                                }
                              });
                            },
                          ),
                          // Conteúdo principal
                          Expanded(
                            child: SingleChildScrollView(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Coluna da esquerda

                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Assign Employees',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                // Botão para mostrar/ocultar a lista de funcionários
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _showEmployeeList =
                                                          !_showEmployeeList;
                                                    });
                                                  },
                                                  child: Text(_showEmployeeList
                                                      ? 'Close Employee List'
                                                      : 'Show Employee List'),
                                                ),
                                                if (_showEmployeeList)
                                                  const SizedBox(height: 16),
                                                if (_showEmployeeList)
                                                  Container(
                                                    height: 500,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: EmployeeListWidget(
                                                        companyId:
                                                            widget.companyId,
                                                        projectId:
                                                            widget.projectId,
                                                        currentUserId:
                                                            widget.currentUserId,
                                                      ),
                                                    ),
                                                  ),
                                                const SizedBox(height: 16),
                                                // Time do projeto
                                                ProjectTeamWidget(
                                                  projectId: widget.projectId,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        ChatCard(
                                          chatId:
                                              '1001', // Substitua pelo ID do chat apropriado
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Coluna da direita
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        CreateTaskCard(
                                          projectId: widget.projectId,
                                          employeeId:
                                              '9d738649-8773-4bf2-b046-39ac3c6f3113', // Ajuste conforme necessário
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProjectTasksScreen(
                      projectId: widget.projectId,
                      currentUserId: widget.currentUserId,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
