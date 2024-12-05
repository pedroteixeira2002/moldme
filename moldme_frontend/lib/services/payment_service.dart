import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/payment_dto.dart';
import '../models/subscriptionPlan.dart';

class PaymentService {
  final String baseUrl = "http://localhost:5213/api/Company";
  final String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQHN0cmluZy5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM1MDc1NDk3LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.ZvbITiUC64dCLOCFiBYmIvO5z9cIR7vWZMtahOmfkpU"; 
  final http.Client client;

  PaymentService({http.Client? client}) : client = client ?? http.Client();

  /// List payment history for a company
  Future<List<PaymentDto>> listPaymentHistory(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/listPaymentHistory');
    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => PaymentDto.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load payment history: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while loading payment history: $e');
    }
  }

  /// Upgrade the subscription plan for a company
  Future<String> upgradePlan(String companyId, SubscriptionPlan subscriptionPlan) async {
    final url = Uri.parse('$baseUrl/$companyId/upgradePlan');
    try {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to upgrade plan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while upgrading plan: $e');
    }
  }

  /// Subscribe to a new plan for a company
  Future<String> subscribePlan(String companyId, SubscriptionPlan subscriptionPlan) async {
    final url = Uri.parse('$baseUrl/$companyId/subscribePlan');
    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to subscribe to plan: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while subscribing to plan: $e');
    }
  }

  /// Cancel the subscription for a company
  Future<String> cancelSubscription(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/cancelSubscription');
    try {
      final response = await client.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to cancel subscription: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while canceling subscription: $e');
    }
  }
}