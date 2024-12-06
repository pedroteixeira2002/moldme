import 'package:flutter/material.dart';

import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart';
import 'package:front_end_moldme/services/offer_service.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/services/project_service.dart';
import 'package:front_end_moldme/dtos/offer_dto.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/dtos/project_dto.dart';

class ApplyToProjectPage extends StatefulWidget {
  final String companyId;
  final String projectId;

  const ApplyToProjectPage(
      {Key? key, required this.companyId, required this.projectId})
      : super(key: key);

  @override
  ApplyToProjectPageState createState() => ApplyToProjectPageState();
}

class ApplyToProjectPageState extends State<ApplyToProjectPage> {
  final TextEditingController descriptionController = TextEditingController();

  CompanyDto? company;
  ProjectDto? project;

  bool isLoading = true;

  OfferService offerService = OfferService();
  CompanyService companyService = CompanyService();
  ProjectService projectService = ProjectService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await Future.wait([_getCompanyData(), _getProjectData()]);
    } catch (e) {
      debugPrint("Erro ao buscar dados: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getCompanyData() async {
    try {
      company = await companyService.getCompanyById(widget.companyId);
      setState(() {});
    } catch (e) {
      debugPrint("Erro ao buscar dados da empresa: $e");
    }
  }

  Future<void> _getProjectData() async {
    try {
      project = await projectService.getProjectById(
          widget.companyId, widget.projectId);
      setState(() {});
    } catch (e) {
      debugPrint("Erro ao buscar dados do projeto: $e");
    }
  }

  Future<void> _sendOffer() async {
    // Verifica se os dados da empresa e do projeto foram carregados
    if (company == null || project == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Company or Project data not loaded yet.')),
      );
      return;
    }

    // Obtenha o valor da descrição do campo de texto
    String description = descriptionController.text.trim();

    // Verifica se a descrição não está vazia
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please provide a description for the offer.')),
      );
      return;
    }

    // Criar um mapa simples apenas com os campos necessários
    Map<String, dynamic> offerJson = {
      'date': DateTime.now().toIso8601String(),
      'status': 5, // Status como inteiro, conforme necessário
      'description': description,
    };

    // Enviar a oferta através do serviço
    try {
      // Enviar a requisição com os dados necessários
      String result = await offerService.sendOffer(
        offerJson as Map<String, dynamic>, // Enviar apenas os dados relevantes
        widget.companyId,
        widget.projectId,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(result)));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          const CustomNavigationBar(),
          Expanded(
            child: AppDrawer(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (company == null || project == null)
                      ? const Center(
                          child: Text('Não foi possível carregar dados.'))
                      : Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24.0),
                                child: Center(
                                  child: Text(
                                    'Apply to Project',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              _buildCompanyCard(company!),
                              const SizedBox(height: 16),
                              _buildProjectCard(project!),
                              SizedBox(height: 16),
                              _buildSectionTitle('Description'),
                              _buildTextField(),
                              SizedBox(height: 16),
                              _buildSectionTitle('Upload Files'),
                              
                              const SizedBox(height: 24),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _sendOffer,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text('Submit Offer'),
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(CompanyDto company) {
    return Card(
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                radius: 24,
              ),
              title: Text(company.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                  const SizedBox(width: 4),
                  Text('Verified',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text('Company Address',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(company.address ?? 'No address available',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            SizedBox(height: 8),
            Text('Sector: ${company.sector}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(ProjectDto project) {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(project.name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              subtitle: Text(project.description),
            ),
            SizedBox(height: 12),
            Text('Budget: \$${project.budget}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Status: ${project.status == 1 ? "Active" : "Inactive"}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            SizedBox(height: 8),
            Text('Start: ${project.startDate.toLocal()}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 4),
            Text('End: ${project.endDate.toLocal()}',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }

  Widget _buildTextField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: descriptionController,
        maxLines: 3,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter a description...',
        ),
      ),
    );
  }


}
