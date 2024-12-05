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
  
  /// Lists payment history of a company
  /*
  Future<List<Payment>> listPaymentHistory(String companyId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/$companyId/listPaymentHistory"),
      headers: {"Authorization": "Bearer YOUR_ACCESS_TOKEN"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> paymentsJson = jsonDecode(response.body);
      return paymentsJson.map((json) => Payment.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch payment history: ${response.body}");
    }
  }
*/
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
}
