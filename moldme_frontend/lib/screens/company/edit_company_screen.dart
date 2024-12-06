import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:front_end_moldme/services/company_service.dart';
import 'package:front_end_moldme/widgets/app_drawer.dart';
import 'package:front_end_moldme/widgets/nav_bar.dart'; // Importa a CustomNavigationBar
/*
class UpdateCompanyScreen extends StatefulWidget {
  // Variável estática para armazenar o companyId
  static String companyId = '1'; // Inicializa com um valor vazio

  @override
  _UpdateCompanyScreenState createState() => _UpdateCompanyScreenState();
}

class _UpdateCompanyScreenState extends State<UpdateCompanyScreen> {
  final CompanyService companyService = CompanyService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();
  final TextEditingController nifController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  late CompanyDto company;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      // Trate o erro ou redirecione para outra página
      print("Erro: Nenhum dado foi passado para a página.");
      return;
    }

    company = args['company'] as CompanyDto;

    // Atribui o companyId da variável estática
    UpdateCompanyScreen.companyId = args['companyId'] as String;

    // Preenche os campos com os dados da empresa
    nameController.text = company.name;
    addressController.text = company.address ?? '';
    contactController.text = company.contact?.toString() ?? '';
    emailController.text = company.email;
    sectorController.text = company.sector;
    nifController.text = company.taxId.toString();
  }

  Future<void> updateCompany() async {
    try {
      // Cria o objeto CompanyDto atualizado
      final updatedCompany = CompanyDto(
        companyId: UpdateCompanyScreen
            .companyId, // Usa a variável estática para pegar o companyId
        name: nameController.text,
        address: addressController.text,
        contact: int.tryParse(contactController.text),
        email: emailController.text,
        sector: sectorController.text,
        taxId: int.tryParse(nifController.text) ?? company.taxId,
        password: passwordController.text.isNotEmpty
            ? passwordController.text
            : company.password,
        plan: SubscriptionPlan.Basic,
      );

      // Chama o serviço para atualizar a empresa
      await companyService.updateCompany(
          UpdateCompanyScreen.companyId, updatedCompany);

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Empresa atualizada com sucesso!')),
      );

      // Volta para a página anterior
      Navigator.pop(context);
    } catch (e) {
      // Mostra uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar a empresa: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomNavigationBar(), // Adiciona a CustomNavigationBar no topo
          Expanded(
            child: AppDrawer(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: [
                      Text(
                        "Atualizar Informações da Empresa",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildTextField("Nome", nameController),
                      const SizedBox(height: 16),
                      _buildTextField("Endereço", addressController),
                      const SizedBox(height: 16),
                      _buildTextField("Email", emailController),
                      const SizedBox(height: 16),
                      _buildTextField("Contato", contactController,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildTextField("Setor", sectorController),
                      const SizedBox(height: 16),
                      _buildTextField("NIF", nifController,
                          keyboardType: TextInputType.number),
                      const SizedBox(height: 16),
                      _buildTextField("Password", passwordController,
                          isPassword: true),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade400),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text(
                              "Cancelar",
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 16),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: updateCompany,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            icon: Icon(Icons.save, color: Colors.white),
                            label: Text(
                              "Guardar alterações",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
    );
  }
}
*/
