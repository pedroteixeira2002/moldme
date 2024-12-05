import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/screens/register/loginScreen.dart';
import 'package:front_end_moldme/services/company_service.dart';

class CheckEmailScreen extends StatefulWidget {
  final Company company;
  
  const CheckEmailScreen({super.key, required this.company});

  @override
  _CheckEmailScreenState createState() => _CheckEmailScreenState();
}

class _CheckEmailScreenState extends State<CheckEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final CompanyService _companyService = CompanyService();

  @override
  void initState() {
    super.initState();
    _completeRegistration();
  }

  void _completeRegistration() async {
    try {
      CompanyDto companyDto = CompanyDto(
        name: widget.company.name,
        taxId: widget.company.taxId,
        address: widget.company.address?.isEmpty ?? true ? "Default Address" : widget.company.address,
        contact: widget.company.contact == null || widget.company.contact! < 100000000 || widget.company.contact! > 999999999 ? 100000000 : widget.company.contact, // Default contact number
        email: widget.company.email,
        sector: widget.company.sector,
        plan: widget.company.plan,
        password: widget.company.password,
      );

      await _companyService.registerCompany(companyDto);
      // Exibir uma mensagem de sucesso ou navegar para outra página, se necessário
    } catch (e) {
      // Tratar erros, exibir uma mensagem de erro, etc.
      print("Failed to register company: $e");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Parte esquerda com imagem decorativa
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/register.png'), // Atualize o caminho se necessário
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Parte direita com texto e checkmark centralizados
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "We’re all done",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Please check your email to use MouldMe!",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        // Navegação para login usando MaterialPageRoute
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                      child: const Text(
                        "Login to your account",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
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
}