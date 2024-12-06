import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';
//import '../models/payment.dart';
import '../dtos/company_dto.dart';
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

class CompanyService {
  final String _baseUrl = "http://localhost:5213/api";

  /// Registers a new company
  Future<void> registerCompany(CompanyDto companyDto) async {
    final url = Uri.parse('$_baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(companyDto.toJson());

    //print('Request URL: $url');
    //print('Request Headers: $headers');
    //print('Request Body: $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data["access_token"];

        // Store the token securely
        await _secureStorage.write(key: "access_token", value: token);
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        print('Company registered successfully');
      } else {
        throw Exception('Failed to register company: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to register company: $e');
    }
  }


  /// Updates the password of a company by email
  Future<void> updatePasswordByEmail(String email, String newPassword) async {
    final url = Uri.parse('$_baseUrl/updatePasswordByEmail');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'email': email,
      'newPassword': newPassword,
    });

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Response Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        print('Password updated successfully');
      } else {
        throw Exception('Failed to update password: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to update password: $e');
    }
  }
  
  /// Upgrades the subscription plan of a company
  Future<void> upgradePlan(String companyId, String subscriptionPlan) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/$companyId/upgradePlan"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer YOUR_ACCESS_TOKEN",
      },
      body: jsonEncode({"subscriptionPlan": subscriptionPlan}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to upgrade plan: ${response.body}");
    }
  }

  /// Cancels the subscription of a company
  Future<void> cancelSubscription(String companyId) async {
    final response = await http.put(
      Uri.parse("$_baseUrl/$companyId/cancelSubscription"),
      headers: {
        "Authorization": "Bearer YOUR_ACCESS_TOKEN",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to cancel subscription: ${response.body}");
    }
  }

  Future<List<CompanyDto>> listAllCompanies() async {
    final url = Uri.parse('$_baseUrl/Company/listAllCompanies');
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
      // Tenta decodificar a resposta diretamente como lista
      final List<dynamic> data = json.decode(response.body);

      // Converte cada item da lista em um CompanyDto
      return data
          .map((e) => CompanyDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception("Failed to fetch companies");
    }
  }

  /// Busca uma empresa pelo ID
  Future<CompanyDto> getCompanyById(String companyId) async {
    final url = Uri.parse(
        'http://localhost:5213/api/Company/$companyId/getCompanyById');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer your_token_here', // Substitua pelo token válido
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return CompanyDto.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception("Company not found: $companyId");
      } else {
        throw Exception("Failed to fetch company: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching company: $e");
    }
  }

  Future<void> updateCompany(
      String companyId, CompanyDto updatedCompany) async {
    final url = Uri.parse('$_baseUrl/Company/$companyId/updateCompany');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkNvbXBhbnkiLCJleHAiOjE3MzUxNjc5MzQsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyJ9.7PwdTYUBjXHzMwa_UB4amJumPi-hs4ypNYaW-pK2I24',
      },
      body: jsonEncode(updatedCompany.toJson()),
    );

    if (response.statusCode == 200) {
      // Atualização bem-sucedida

    } else {
      // Falha na atualização, você pode obter mais detalhes da resposta
     
      throw Exception('Falha ao atualizar empresa');
    }
  }
}
