import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dtos/company_dto.dart';

class CompanyService {
  final String baseUrl = "http://localhost:5213";
  final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJ0aWFnb0BnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM0NzM0OTUxLCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.B4clMA8cuR4cH6YPs9WbYSbr6PQeb3TE8IaeH7_ixFA"; // Replace with actual token

  /// Registers a new company.
  Future<Map<String, dynamic>> registerCompany(CompanyDto companyDto) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(companyDto.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        json.decode(response.body)['error'] ?? "Failed to register company",
      );
    }
  }

  /// Lists the payment history for a specific company.
  Future<List<dynamic>> listPaymentHistory(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/listPaymentHistory');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        json.decode(response.body)['error'] ?? "Failed to fetch payment history",
      );
    }
  }

  /// Upgrades the subscription plan for a company.
  Future<String> upgradePlan(String companyId, String subscriptionPlan) async {
    final url = Uri.parse('$baseUrl/$companyId/upgradePlan');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(subscriptionPlan),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        json.decode(response.body)['error'] ?? "Failed to upgrade plan",
      );
    }
  }

  /// Subscribes the company to a plan.
  Future<String> subscribePlan(String companyId, String subscriptionPlan) async {
    final url = Uri.parse('$baseUrl/$companyId/subscribePlan');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(subscriptionPlan),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        json.decode(response.body)['error'] ?? "Failed to subscribe to plan",
      );
    }
  }

  /// Cancels the subscription for a company.
  Future<String> cancelSubscription(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/cancelSubscription');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(
        json.decode(response.body)['error'] ?? "Failed to cancel subscription",
      );
    }
  }
}
