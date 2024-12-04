import 'dart:convert';
import 'package:front_end_moldme/models/company.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  final String baseUrl = "http://localhost:5213/api/Company";

  /// Lista todas as empresas
  Future<List<Company>> listAllCompanies() async {
    final url = Uri.parse('$baseUrl/listAllCompanies');
    const String token =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."; // Substitua pelo token válido

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> values = data['\$values'];

      return values.map((e) => Company.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch companies");
    }
  }

  /// Busca uma empresa pelo ID
  Future<Company> getCompanyById(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/getCompanyById');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer your_token_here', // Insira o token aqui
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Company.fromJson(data);
    } else {
      throw Exception("Failed to fetch company: ${response.statusCode}");
    }
  }
}
