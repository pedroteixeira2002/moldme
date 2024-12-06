import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:http/http.dart' as http;

import '../dtos/company_dto.dart';
final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

class CompanyService {
  final String _baseUrl = "https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net/api";
  final AuthenticationService _authenticationService = AuthenticationService();

  final http.Client client;

  CompanyService({http.Client? client}) : client = client ?? http.Client();

  /// Registers a new company
  Future<void> registerCompany(CompanyDto companyDto) async {
    final url = Uri.parse('$_baseUrl/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(companyDto.toJson());

    //print('Request URL: $url');
    //print('Request Headers: $headers');
    //print('Request Body: $body');

    try {
      final response = await client.post(url, headers: headers, body: body);

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
      final response = await client.put(url, headers: headers, body: body);

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
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await client.put(
      Uri.parse("$_baseUrl/$companyId/upgradePlan"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"subscriptionPlan": subscriptionPlan}),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to upgrade plan: ${response.body}");
    }
  }

  /// Cancels the subscription of a company
  Future<void> cancelSubscription(String companyId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await client.put(
      Uri.parse("$_baseUrl/$companyId/cancelSubscription"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to cancel subscription: ${response.body}");
    }
  }

  Future<List<CompanyDto>> listAllCompanies() async {
    final url = Uri.parse('$_baseUrl/Company/listAllCompanies');
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await client.get(
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

  /// Pesquisa uma empresa pelo ID
  Future<CompanyDto> getCompanyById(String companyId) async {
    final url = Uri.parse('$_baseUrl/Company/$companyId');
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Usa o token obtido
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

  /// Atualiza uma empresa
  Future<void> updateCompany(String companyId, CompanyDto updatedCompany) async {
    final url = Uri.parse('$_baseUrl/Company/$companyId/updateCompany');
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final response = await client.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
      body: jsonEncode(updatedCompany.toJson()),
    );

    if (response.statusCode == 200) {
      // Atualização bem-sucedida
    } else {
      // Falha na atualização, você pode obter mais detalhes da resposta
      throw Exception('Failed to update company: ${response.body}');
    }
  }
}
